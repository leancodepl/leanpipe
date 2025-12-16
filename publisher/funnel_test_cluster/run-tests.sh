#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

CLUSTER_NAME="testapp"
WAIT_TIMEOUT=${WAIT_TIMEOUT:-300}  # 5 minutes default, in seconds

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

log() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
error() { echo -e "${RED}[ERROR]${NC} $1"; }

check_prerequisites() {
    log "Checking prerequisites..."
    local missing=()

    command -v k3d &> /dev/null || missing+=("k3d")
    command -v tilt &> /dev/null || missing+=("tilt")
    command -v kubectl &> /dev/null || missing+=("kubectl")
    command -v docker &> /dev/null || missing+=("docker")
    command -v dotnet &> /dev/null || missing+=("dotnet")

    if [ ${#missing[@]} -ne 0 ]; then
        error "Missing required tools: ${missing[*]}"
        exit 1
    fi
    log "All prerequisites found."
}

create_cluster() {
    if k3d cluster list | grep -q "^${CLUSTER_NAME} "; then
        log "Cluster '${CLUSTER_NAME}' already exists."

        # Check if it's running
        if k3d cluster list | grep "^${CLUSTER_NAME} " | grep -q "0/1"; then
            log "Starting stopped cluster..."
            k3d cluster start "${CLUSTER_NAME}"
        fi
    else
        log "Creating k3d cluster '${CLUSTER_NAME}'..."
        k3d cluster create --config k3d.yaml
    fi

    kubectl cluster-info
}

run_tests() {
    log "Running tilt ci (timeout: ${WAIT_TIMEOUT}s)..."

    local exit_code=0

    # tilt ci handles: build, deploy, wait for completion, exit codes
    # --output-snapshot-on-exit saves debug info for inspection on failure
    tilt ci --timeout "${WAIT_TIMEOUT}s" --output-snapshot-on-exit snapshot.json || exit_code=$?

    if [ $exit_code -ne 0 ]; then
        error "tilt ci failed with exit code $exit_code"
        warn "Debug snapshot saved to: snapshot.json"
        warn "View with: tilt snapshot view snapshot.json"
    fi

    return $exit_code
}

show_results() {
    log "Test Results:"
    echo "=============================================="

    local all_passed=true
    local namespaces=("no-scaling" "scaled-target-service" "scaled-funnel" "multiple-services")

    for ns in "${namespaces[@]}"; do
        local pod=$(kubectl get pods -n "$ns" 2>/dev/null | grep "tests-" | head -1 | awk '{print $1}')

        if [ -n "$pod" ]; then
            local status=$(kubectl get pod -n "$ns" "$pod" -o jsonpath='{.status.phase}' 2>/dev/null)
            local result=$(kubectl logs -n "$ns" "$pod" 2>/dev/null | grep -E "Test run summary: (Passed|Failed)!" | tail -1)

            if echo "$result" | grep -q "Passed!"; then
                echo -e "${GREEN}✓${NC} ${ns}: ${result}"
            else
                echo -e "${RED}✗${NC} ${ns}: ${result:-FAILED (status: $status)}"
                all_passed=false

                # Show error details
                echo "  Error details:"
                kubectl logs -n "$ns" "$pod" 2>/dev/null | grep -A 5 -E "(Error Message:|failed:)" | head -10 | sed 's/^/    /'
            fi
        else
            echo -e "${RED}✗${NC} ${ns}: No test pod found"
            all_passed=false
        fi
    done

    echo "=============================================="

    if $all_passed; then
        log "All tests passed! 🎉"
        return 0
    else
        error "Some tests failed."
        return 1
    fi
}

collect_logs() {
    log "Collecting test logs..."
    mkdir -p test-logs

    # Clear previous logs
    > test-logs/test-results.txt
    > test-logs/pod-status.txt
    > test-logs/pod-describe.txt

    for ns in no-scaling scaled-target-service scaled-funnel multiple-services; do
        echo "=== Namespace: $ns ===" >> test-logs/test-results.txt
        pod=$(kubectl get pods -n $ns -o name 2>/dev/null | grep tests | head -1)
        if [ -n "$pod" ]; then
            kubectl logs -n $ns $pod >> test-logs/test-results.txt 2>&1 || true
        fi
        echo "" >> test-logs/test-results.txt
    done

    kubectl get pods -A >> test-logs/pod-status.txt 2>&1 || true
    kubectl describe pods -A >> test-logs/pod-describe.txt 2>&1 || true

    log "Logs collected in test-logs/"
}

cleanup() {
    log "Cleaning up..."
    tilt down 2>/dev/null || true
}

delete_cluster() {
    log "Deleting cluster '${CLUSTER_NAME}'..."
    k3d cluster delete "${CLUSTER_NAME}"
}

# Main
case "${1:-run}" in
    run)
        check_prerequisites
        create_cluster

        test_exit_code=0
        run_tests || test_exit_code=$?

        show_results || true

        if [ $test_exit_code -ne 0 ]; then
            collect_logs
        fi

        exit $test_exit_code
        ;;
    ci)
        # CI mode: skip cluster creation (handled by CI), just run tests
        check_prerequisites

        test_exit_code=0
        run_tests || test_exit_code=$?

        show_results || true

        if [ $test_exit_code -ne 0 ]; then
            collect_logs
        fi

        exit $test_exit_code
        ;;
    results)
        show_results
        ;;
    cleanup)
        cleanup
        ;;
    delete)
        cleanup
        delete_cluster
        ;;
    *)
        echo "Usage: $0 {run|ci|results|cleanup|delete}"
        echo ""
        echo "Commands:"
        echo "  run      - Create cluster, run tests, show results (default)"
        echo "  ci       - Run tests only (cluster already exists, for CI use)"
        echo "  results  - Show results from previous run"
        echo "  cleanup  - Stop Tilt and clean up deployments"
        echo "  delete   - Delete the k3d cluster entirely"
        echo ""
        echo "Environment variables:"
        echo "  WAIT_TIMEOUT - Timeout in seconds (default: 300)"
        exit 1
        ;;
esac
