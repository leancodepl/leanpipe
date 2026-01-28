# js-client - LeanPipe JavaScript/TypeScript client libraries

JavaScript and TypeScript client libraries for the LeanPipe real-time data streaming system. Provides type-safe,
reactive clients for subscribing to server-sent data streams.

## Installation

### Core Package

```bash
npm install @leancodepl/pipe
```

## Packages

### @leancodepl/pipe

Real-time data streaming client for LeanPipe.

For detailed API documentation and examples, see the [@leancodepl/pipe README](./packages/pipe/README.md).

## Development

### Publishing

1. Create a new branch, name it `release-js-client/[version]` e.g. `release-js-client/1.2.3`
2. Push that empty branch to the remote (required for the next step to work).
3. Run `npx lerna version [version]` e.g. `npx lerna version 1.2.3`. This command will automatically bump versions
   across all files and push the changes.
4. Create a new pull request for this branch.
5. Go to the `Actions` tab, and then `Release` workflow. Expand the `Run workflow` menu, from the `Tags` tab choose your
   new version and run the workflow.
6. After refreshing the page you should be able to see the workflow running. After it finishes successfully, go back to
   the previously created PR and merge it.

### Building

```bash
npm install
npm run build
```

### Testing

```bash
npm test
```
