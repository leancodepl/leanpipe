# LeanPipe Funnel Scaling Tests

These tests verify that LeanPipe's Funnel architecture works correctly in scaled Kubernetes environments with multiple service replicas.

## Prerequisites

- [k3d](https://k3d.io/) - Lightweight Kubernetes in Docker
- [Tilt](https://tilt.dev/) - Local Kubernetes development tool
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://www.docker.com/)
- [.NET 10.0 SDK](https://dotnet.microsoft.com/)

## Quick Start

```bash
# Run all tests
./run-tests.sh

# Or step by step:
./run-tests.sh run      # Create cluster, deploy, run tests
./run-tests.sh results  # Show results from previous run
./run-tests.sh cleanup  # Stop Tilt, clean up deployments
./run-tests.sh delete   # Delete the k3d cluster
```

## Test Suites

| Test                      | Description                                   |
|---------------------------|-----------------------------------------------|
| **no-scaling**            | Single funnel + single service instance       |
| **scaled-target-service** | Single funnel + 2 service replicas            |
| **scaled-funnel**         | 2 funnel replicas + single service            |
| **multiple-services**     | Multiple different services behind one funnel |

## Manual Steps

### 1. Create the Cluster

```bash
cd funnel_test_cluster
k3d cluster create --config k3d.yaml
```

### 2. Run Tilt

```bash
tilt up
# Or with streaming logs:
tilt up --stream
```

Open http://localhost:10350 to see the Tilt UI.

### 3. Check Test Results

```bash
# View pod status
kubectl get pods -A | grep tests

# View test logs
kubectl logs -n no-scaling $(kubectl get pods -n no-scaling -o name | grep tests)
kubectl logs -n scaled-target-service $(kubectl get pods -n scaled-target-service -o name | grep tests)
kubectl logs -n scaled-funnel $(kubectl get pods -n scaled-funnel -o name | grep tests)
kubectl logs -n multiple-services $(kubectl get pods -n multiple-services -o name | grep tests)
```

### 4. Cleanup

```bash
tilt down
k3d cluster delete testapp
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    Kubernetes Cluster                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌──────────┐     ┌─────────────┐     ┌─────────────────┐   │
│  │ RabbitMQ │◄────│   Funnel    │◄────│  Test Client    │   │
│  │ (4 nodes)│     │ (SignalR)   │     │  (xUnit tests)  │   │
│  └────┬─────┘     └─────────────┘     └─────────────────┘   │
│       │                                                     │
│       ▼                                                     │
│  ┌─────────────────────────────────────────────────────┐    │
│  │              Target Services                        │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────┐           │    │
│  │  │ TestApp1 │  │ TestApp1 │  │ TestApp2 │  (scaled) │    │
│  │  │ (pod 0)  │  │ (pod 1)  │  │          │           │    │
│  │  └──────────┘  └──────────┘  └──────────┘           │    │
│  └─────────────────────────────────────────────────────┘    │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

## Troubleshooting

### Tests fail with "Name or service not known"

The test pods can't reach the services. Check that all service pods are running:

```bash
kubectl get pods -A
```

**Expected result:** All pods should show `Running` or `Completed` status:

```
NAMESPACE              NAME                          READY   STATUS      RESTARTS   AGE
no-scaling             funnel-xxx                    1/1     Running     0          2m
no-scaling             testapp1-xxx                  1/1     Running     0          2m
scaled-funnel          funnel-xxx                    1/1     Running     0          2m
...
```

**If pods are not running:**

1. Check pod logs for errors:
   ```bash
   kubectl logs -n <namespace> <pod-name>
   ```

2. Describe the pod to see events:
   ```bash
   kubectl describe pod -n <namespace> <pod-name>
   ```

3. Common issues:
   - `ImagePullBackOff` - Docker image not built; run `tilt up` again
   - `CrashLoopBackOff` - Application error; check logs
   - `Pending` - Resource constraints; check node resources with `kubectl describe nodes`

### RabbitMQ RESOURCE_LOCKED error

This indicates multiple service instances are trying to create the same exclusive queue. Ensure each instance has a unique `InstanceId` in the MassTransit configuration.

### Timeout waiting for tests

Increase the timeout:

```bash
WAIT_TIMEOUT=600 ./run-tests.sh
```

### Port conflicts

The cluster uses ports 80, 443, 5432, 10000. Ensure these are free or modify `k3d.yaml`.

