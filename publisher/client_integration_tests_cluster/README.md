# LeanPipe Client Integration Tests Cluster

This cluster provides a local Kubernetes environment for developing and testing LeanPipe client libraries:

- **Dart/Flutter**: `leancode_pipe` package (`~/leancode/leanpipe/dart`)
- **JavaScript/TypeScript**: `@leancode/pipe` package (`~/leancode/leanpipe/js-client`)

It deploys the test backend application that clients can connect to during development.

## Prerequisites

- [k3d](https://k3d.io/) - Lightweight Kubernetes in Docker
- [Tilt](https://tilt.dev/) - Local Kubernetes development tool
- [kubectl](https://kubernetes.io/docs/tasks/tools/)
- [Docker](https://www.docker.com/)
- [.NET 10.0 SDK](https://dotnet.microsoft.com/)

## Quick Start

```bash
cd publisher/client_integration_tests_cluster

# Create the cluster
k3d cluster create --config k3d.yaml

# Start Tilt (builds and deploys the test backend)
tilt up

# Open Tilt UI at http://localhost:10350
```

## What Gets Deployed

The cluster deploys two instances of `LeanCode.Pipe.ClientIntegrationTestsApp`:

| Service                  | Funnel Mode | Description                        |
|--------------------------|-------------|------------------------------------|
| `testapp-disabledfunnel` | Disabled    | Standard LeanPipe (direct SignalR) |
| `testapp-enabledfunnel`  | Enabled     | LeanPipe with Funnel architecture  |

## Connecting Client Libraries

### Accessing the Backend

Use port-forwarding to expose the services locally:

```bash
# Standard mode (funnel disabled)
kubectl port-forward svc/testapp-disabledfunnel 8080:80

# Funnel mode (funnel enabled)
kubectl port-forward svc/testapp-enabledfunnel 8081:80
```

### Dart Client (`leancode_pipe`)

```dart
import 'package:leancode_pipe/leancode_pipe.dart';

final client = PipeClient(
  pipeUrl: 'http://localhost:8080/leanpipe',
  tokenFactory: () async => 'your-auth-token',
);

await client.connect();

// Subscribe to a topic
final subscription = await client.subscribe(YourTopic());
subscription.listen((notification) {
  print('Received: $notification');
});
```

### TypeScript Client (`@leancode/pipe`)

```typescript
import { Pipe } from "@leancode/pipe";

const pipe = new Pipe({
  url: "http://localhost:8080/leanpipe",
  options: {
    accessTokenFactory: () => "your-auth-token",
  },
});

// Subscribe to a topic
const notifications$ = pipe.topic<YourNotifications>("YourTopicType", { id: "123" });
notifications$.subscribe(([type, data]) => {
  console.log(`Received ${type}:`, data);
});
```

## Running Dart Client Integration Tests

The Dart client has its own integration tests that use this cluster:

```bash
cd ~/leancode/leanpipe/dart/publisher_integration_tests

# This includes the publisher cluster Tiltfile automatically
tilt up
```

This will:
1. Deploy the test backend (from this cluster)
2. Build and run Dart client integration tests against both funnel modes

## Architecture

```
┌─────────────────────────────────────────────────────────┐
│              k3d-clientintegrationtests                 │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  ┌────────────────────────┐   ┌───────────────────────┐ │
│  │ testapp-disabledfunnel │   │ testapp-enabledfunnel │ │
│  │   (EnableFunnel=false) │   │   (EnableFunnel=true) │ │
│  │        :80             │   │        :80            │ │
│  └────────────────────────┘   └───────────────────────┘ │
│                                                         │
└──────────────────────┬──────────────────────────────────┘
                       │ port-forward :8080/:8081
                       ▼
              ┌─────────────────┐
              │  Client Apps    │
              │  - Dart/Flutter │
              │  - JS/TS        │
              └─────────────────┘
```

## Development Workflow

1. Start the cluster and Tilt
2. Port-forward the desired service
3. Develop your client library locally
4. Point your client at `http://localhost:8080/leanpipe`
5. Changes to the backend are auto-rebuilt by Tilt

### Checking Backend Status

```bash
kubectl get pods
kubectl get svc
kubectl logs deployment/testapp-disabledfunnel
kubectl logs deployment/testapp-enabledfunnel
```

## Cleanup

```bash
# Stop Tilt and remove deployments
tilt down

# Delete the cluster
k3d cluster delete clientintegrationtests
```

## Configuration

### Cluster Configuration (`k3d.yaml`)

- **Cluster name**: `clientintegrationtests`
- **Kubernetes API**: `localhost:6445`
- **Exposed ports**: 80, 443, 1433, 5432, 10000
- **Registry**: `localhost:21345`

### Tilt Configuration (`Tiltfile`)

- Builds the test backend using `dotnet publish`
- Creates Docker image using `testapp.dockerfile`
- Deploys two variants with different `EnableFunnel` environment variable
- Auto-rebuilds on source changes
