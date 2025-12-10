#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

CLUSTER_NAME="testapp"
WAIT_TIMEOUT=${WAIT_TIMEOUT:-300}  # 5 minutes default

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

cleanup_namespaces() {
    log "Cleaning up test namespaces..."
    kubectl delete namespace no-scaling scaled-target-service scaled-funnel multiple-services --ignore-not-found 2>/dev/null || true
}

run_tilt() {
    log "Starting Tilt (building and deploying services)..."

    # Kill any existing tilt processes
    pkill -f "tilt up" 2>/dev/null || true
    sleep 2

    # Start tilt in background
    tilt up --stream &
    TILT_PID=$!

    log "Waiting for tests to complete (timeout: ${WAIT_TIMEOUT}s)..."

    local start_time=$(date +%s)
    local all_completed=false

    while true; do
        local current_time=$(date +%s)
        local elapsed=$((current_time - start_time))

        if [ $elapsed -ge $WAIT_TIMEOUT ]; then
            error "Timeout waiting for tests to complete"
            kill $TILT_PID 2>/dev/null || true
            exit 1
        fi

        # Check if all test pods are completed
        local test_pods=$(kubectl get pods -A 2>/dev/null | grep -E "tests-" | grep -v "NAME" || true)

        if [ -n "$test_pods" ]; then
            local total=$(echo "$test_pods" | wc -l)
            local completed=$(echo "$test_pods" | grep -c "Completed" || true)
            local errors=$(echo "$test_pods" | grep -c "Error" || true)

            if [ "$completed" -eq 4 ] || [ $((completed + errors)) -eq 4 ]; then
                all_completed=true
                break
            fi

            log "Progress: $completed/4 tests completed, $errors errors (${elapsed}s elapsed)"
        fi

        sleep 10
    done

    # Stop tilt
    kill $TILT_PID 2>/dev/null || true
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
            local result=$(kubectl logs -n "$ns" "$pod" 2>/dev/null | grep -E "^(Passed|Failed)!" | tail -1)

            if echo "$result" | grep -q "Passed!"; then
                echo -e "${GREEN}✓${NC} ${ns}: ${result}"
            else
                echo -e "${RED}✗${NC} ${ns}: ${result:-FAILED}"
                all_passed=false

                # Show error details
                echo "  Error details:"
                kubectl logs -n "$ns" "$pod" 2>/dev/null | grep -A 5 "Error Message:" | head -10 | sed 's/^/    /'
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

cleanup() {
    log "Cleaning up..."
    pkill -f "tilt up" 2>/dev/null || true
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
        cleanup_namespaces
        run_tilt
        show_results
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
      echo "Usage: $0 {run|results|cleanup|delete}"
        echo ""
        echo "Commands:"
        echo "  run      - Create cluster, run tests, show results (default)"
        echo "  results  - Show results from previous run"
        echo "  cleanup  - Stop Tilt and clean up deployments"
        echo "  delete   - Delete the k3d cluster entirely"
        echo ""
        echo "Environment variables:"
        echo "  WAIT_TIMEOUT - Timeout in seconds (default: 300)"
        exit 1
        ;;
esac
