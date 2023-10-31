# LeanPipe

Real time server-to-client strongly typed notifications in a pub-sub manner.
Notifying is backed up by [SignalR](https://dotnet.microsoft.com/en-us/apps/aspnet/signalr), while seamless server to client contracts generation is handled by [LeanCode Contracts Generator](https://github.com/leancodepl/contractsgenerator).

> Postmen have a legendary aura. A ring at the doorbell may inflame a sense of expectation, suspense, secrecy, hazard or even intrigue. Ringing twice may imply a warning that trouble is on the way or an appeal to make the coast clear. ~ "The postman always rings twice", Erik Pevernagie

## Core concepts

Backend defines **Topics** including parameters they have and **Notifications** that may be received by the clients that **Subscribe** to them.
LeanPipe Backend, which also handles **Publishing** notifications to topics, is called the **Publisher**.
End clients that subscribe to topics and then receive notifications are just **Clients**.

The topics may require some arbitrary permissions from the clients that subscribe to them.

Before subscribing to any topic the SignalR Connection to the Publisher is established by the Client.

## LeanPipe core parts

In order to setup real time notifications via LeanPipe in an app one would need a Publisher server and at least one of the provided clients.

### Publisher

Handles clients subscriptions to the topics and allows publishing to them.

Available as a library for monolithic architectures and also as a microservice friendly reverse proxy called the Funnel.

See more [here](publisher/README.md).

### Client SDKs

The clients allow subscribing to various notification topics and receive real time, strongly typed notifications published on the topic.

Supported LeanPipe client SDKs:

1. [Dart](dart/README.md)
2. TypeScript [TBD]
