# LeanCode Pipe

Real time server-to-client strongly typed notifications in a pub-sub manner.
Notifying is backed up by [SignalR](https://dotnet.microsoft.com/en-us/apps/aspnet/signalr), while seamless server to client contracts generation is handled by [LeanCode Contracts Generator](https://github.com/leancodepl/contractsgenerator).

> Postmen have a legendary aura. A ring at the doorbell may inflame a sense of expectation, suspense, secrecy, hazard or even intrigue. Ringing twice may imply a warning that trouble is on the way or an appeal to make the coast clear. ~ "The postman always rings twice", Erik Pevernagie

## Pipe parts

In order to receive notifications via Pipe one would need a publisher server and at least one of the provided clients.

### [Pipe publisher](publisher/README.md)

Pipe part that handles clients subscriptions to the topics and allows publishing to them.

### Pipe clients
The clients allow subscribing to various notification topics and receive real time, strongly typed notifications published by the publisher on the topic.

Existing Pipe clients:

1. Dart [TBD]
2. TypeScript [TBD]

## Pipe concepts

[TODO]
