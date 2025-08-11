# js-client - LeanPipe JavaScript/TypeScript client libraries

JavaScript and TypeScript client libraries for the LeanPipe real-time data streaming system. Provides type-safe, reactive clients for subscribing to server-sent data streams.

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

1. Checkout to the branch with your changes, before publishing you should already have an approved pull request with these changes.
2. Run `npx lerna version [version]` e.g. `npx lerna version 1.2.3`. This command will automatically bump versions across all files and push the changes.
3. Publishing will start automatically. After it finishes, merge the pull request.

### Building

```bash
npm install
npm run build
```

### Testing

```bash
npm test
```
