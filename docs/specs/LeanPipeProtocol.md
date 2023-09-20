# LeanPipe Protocol

The LeanPipe Protocol is a pub-sub messaging over the [SignalR Protocol](https://github.com/dotnet/aspnetcore/blob/main/src/SignalR/docs/specs/HubProtocol.md) connections.
Clients may subscribe to various topics in order to receive notifications when the Publisher publishes them.
Intended to be used in pair with the [Contracts Generator](https://github.com/leancodepl/contractsgenerator).

## Terms
* Publisher - The singular node that is handling Connections and `Subscribe`, `Unsubscribe` invocations and issuing `subscriptionResult`, `notify` invocations.
* Client - The node that is issuing Connections and `Subscribe`, `Unsubscribe` invocations and handling `subscriptionResult`, `notify` invocations.
* Connection - The established SignalR connection between Client and Publisher.
* Topic - The template specifying subscription parameters, required Client permissions to subscribe and the pool of received notification types by Clients subscribed to the Topic Instances.
* Topic Instance - The Topic with concrete parameters provided.
  Publisher may publish Notifications to the Topic Instance for subscribed Clients to receive them.
  Clients can subscribe and then receive published Notifications.
* Subscription - An arrangement between Publisher and Client over established Connection on particular Topic Instance to receive Notifications specified by the topic.
* Notification - A message sent by the Publisher to the Clients subscribed to the particular Topic Instance.

## Transport
The LeanPipe protocol uses the SignalR protocol as the duplex message protocol.
SignalR supports various transports underneath, each allowing for reliable, in-order, delivery of messages.
The [supported transports](https://github.com/dotnet/aspnetcore/blob/main/src/SignalR/docs/specs/TransportProtocols.md) are:
* WebSockets (Full Duplex),
* HTTP Post (Client-to-Server only),
* Server-Sent Events (Server-to-Client only),
* Long Polling (Server-to-Client only).

The default transport that will be established the vast majority of times will be WebSockets.

## Overview

This document describes necessary steps to perform by the Client in order to receive Notifications related to the particular Topic Instance of interest, on the Topic specified by the Publisher Instance.
The first step is always establishing a Connection and all other steps are performed as the SignalR invocations on the singular established Connection.

In the LeanPipe protocol, the following types of invocations may be issued:

| Invocation name      | Issuer    | Description                                                                                                                |
|----------------------|-----------|----------------------------------------------------------------------------------------------------------------------------|
| `Subscribe`          | Client    | Indicates a request to the Publisher to establish a subscription.                                                          |
| `Unsubscribe`        | Client    | Indicates a request to the Publisher to sever the established subscription.                                                |
| `subscriptionResult` | Publisher | Sent by the Publisher to the Client to notify about result of the `Subscribe`/`Unsubscribe` attempt.                       |
| `notify`             | Publisher | A notification sent by the Publisher to all Clients that have established a subscription on the particular topic instance. |

## Subscribing to a Topic Instance and Unsubscribing from it

In order for the Client to subscribe to the particular Topic Instance, the following steps are to be executed:
1. Establish a SignalR connection with the Publisher if it is not established already,
2. Request establishing subscription to the Topic instance via `Subscribe` invocation.
3. Wait for the `subscriptionResult` invocation from the Publisher, that is correlated to the prior `Subscribe` invocation.
4. If the received payload of `subscriptionResult` indicates success, prepare for handling `notify` invocations on the established Connection with the Notifications payload of one of the Notifications specified by the Topic.

Establishing a Connection and performing steps are described in detail below.

In order for the Client to unsubscribe from the particular Topic Instance, the following steps are to be executed:

1. If the Connection is **not** established:
   1. The Client is unsubscribed from all topic instances.
      Severing a connection is a valid way of unsubscribing, but it removes all Client subscriptions.
2. Request severing the subscription to the Topic instance via `Unsubscribe` invocation.
3. Wait for the `subscriptionResult` invocation from the Publisher, that is correlated to the prior `Unsubscribe` invocation.
4. If the received payload of `subscriptionResult` indicates success `notify` invocations on the established Connection with the Notifications payload of one of the Notifications specified by the Topic are not to be expected anymore.

### Connection

The LeanPipe protocol expects the Client to maintain a singular SignalR connection to subscribe, unsubscribe and receive notifications.
Establishing the Connection is always the Clients responsibility.
So is reconnecting in case when the connection is severed due to some random events (e.g. losing access to the network).

⚠️ Severing the connection by any means always means losing all established subscriptions, should a new connection be established once more.

To establish a SignalR connection the SignalR protocol with JSON encoding must be followed.
It is specified [here](https://github.com/dotnet/aspnetcore/blame/main/src/SignalR/docs/specs/HubProtocol.md).

#### Authenticated Connection

Some Topics may require the authenticated entity of the Client with the Connection to have some permissions to allow subscribing to its Instances.
Such permissions are defined with the [authorization attributes](https://github.com/leancodepl/contractsgenerator/blob/209f8f4354fc4755879d1fd38d6e7293858ded42/docs/tutorial.md#attributes).

Would an entity establishing a connection like to authenticate, it must follow one of the standard patterns:

1. Include an [Authorization Header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Authorization) in the initial SignalR HTTP request,
2. Include a [Cookie Header](https://developer.mozilla.org/en-US/docs/Web/HTTP/Cookies) with expected tokens  in the initial SignalR HTTP request.

⚠️ Web browser WebSocket clients are restricted to including only a `Sec-WebSocket-Protocol` header, so the `1.` authentication option is not available to them.

Authentication result of the Connection is persisted through whole lifetime of the Connection.

### Subscribe

`Subscribe` is a request by Client to the Publisher to establish a subscription on the provided topic instance.

It is performed with the `Subscribe` invocation over the Connection.
The message payload should contain a [SubscriptionEnvelope](https://github.com/leancodepl/contractsgenerator/blob/main/src/LeanCode.Contracts/SubscriptionEnvelope.cs) serialized to JSON.

The `Subscribe` message contains the following properties:

* `Id` (`Guid`) - Subscription ID for response correlation purposes on the client. Must be generated on the client.
* `TopicType` (`string`) - The topics [type descriptor name](https://github.com/leancodepl/contractsgenerator/blob/209f8f4354fc4755879d1fd38d6e7293858ded42/contracts.proto#L162) from the generated contracts.
* `Topic` (`JsonDocument`) - The serialized Topic Instance the Client requests to subscribe to.

Example:

```json
{
    "Id": "f910215f-ffe4-4619-8d08-32d26d9a164c",
    "TopicType": "ExampleApp.Core.Contracts.Projects.ProjectEmployeesAssignmentsTopic",
    "Topic": {
        "ProjectId": "project_01H9JQRCXQ2RP0BY9R4C7B6JM0"
    }
}
```

Once the subscription request message is sent, the Client should await the `subscriptionResult` invocation.

`Subscribe` invocation is idempotent.

#### Subscription Result

`subscriptionResult` invocation should be expected by the Client after performing the `Subscribe` or `Unsubscribe` invocation.
The message payload will contain a [SubscriptionResult](https://github.com/leancodepl/contractsgenerator/blob/main/src/LeanCode.Contracts/SubscriptionResult.cs) serialized to JSON.

The `subscriptionResult` message contains the following properties:

* `SubscriptionId` (`Guid`) - The same subscription ID as provided in the request by the client.
  Must be used to correlate with the initial request.
* `Type` (`OperationType`) - Enum indicating whether it is response a for `Subscribe` (`0`) or `Unsubscribe` (`1`).
  Must be used to correlate with the initial request.
* `Status` (`SubscriptionStatus`) - The subscription result enum. Its possible values are:
  * `Unauthorized` (`1`) - The connection may be not authenticated or have insufficient permissions for subscribing the authorized topic instance.
  * `Malformed` (`2`) - The `Subscribe`/`Unsubscribe` message was malformed. Discovered when deserializing the message.
  * `Invalid` (`3`) - The `Subscribe`/`Unsubscribe` request message could not be interpreted properly within publisher state.
  * `InternalServerError` (`4`) - The Publisher encountered an unexpected state that prevents it from fulfilling the `Subscribe`/`Unsubscribe` request.
  * `Success` (`0`) - The Publisher successfully established/severed the subscription.

Example:

```json
{
  "SubscriptionId":"f910215f-ffe4-4619-8d08-32d26d9a164c",
  "Status":0,
  "Type":0
}
```

### Unsubscribe

`Unsubscribe` is a request by Client to the Publisher to sever a subscription on the provided topic instance.

It is performed with the `Unsubscribe` invocation over the Connection.
The message payload should contain a [SubscriptionEnvelope](https://github.com/leancodepl/contractsgenerator/blob/main/src/LeanCode.Contracts/SubscriptionEnvelope.cs) serialized to JSON.

The `Unsubscribe` message contains the following properties:

* `Id` (`Guid`) - Subscription ID for response correlation purposes on the client.
  Must be the same as the Subscription ID used in the `Subscribe` request.
* `TopicType` (`string`) - The topics [type descriptor name](https://github.com/leancodepl/contractsgenerator/blob/209f8f4354fc4755879d1fd38d6e7293858ded42/contracts.proto#L162) from the generated contracts.
* `Topic` (`JsonDocument`) - The serialized Topic Instance the Client requests to unsubscribe from.

Example:

```json
{
    "Id": "f910215f-ffe4-4619-8d08-32d26d9a164c",
    "TopicType": "ExampleApp.Core.Contracts.Projects.ProjectEmployeesAssignmentsTopic",
    "Topic": {
        "ProjectId": "project_01H9JQRCXQ2RP0BY9R4C7B6JM0"
    }
}
```

Once the unsubscription request message is sent, the Client should await the `subscriptionResult` invocation.
It is specified in the [Subscription Result](#subscription-result) section.

`Unsubscribe` invocation is idempotent.

## Receiving Notifications

When the Client has a successfully established subscription it should be prepared for handling `notify` invocations over the Connection with Notifications specified by the Topic.
The message payload will contain a [NotificationEnvelope](https://github.com/leancodepl/contractsgenerator/blob/main/src/LeanCode.Contracts/NotificationEnvelope.cs) serialized to JSON.

The `notify` message contains the following properties:

* `Id` (`Guid`) - Notification ID. For debugging purposes.
* `TopicType` (`string`) - The topics [type descriptor name](https://github.com/leancodepl/contractsgenerator/blob/209f8f4354fc4755879d1fd38d6e7293858ded42/contracts.proto#L162) from the generated contracts the Client receives Notification from.
* `NotificationType` (`string`) - The notifications [tag](https://github.com/leancodepl/contractsgenerator/blob/209f8f4354fc4755879d1fd38d6e7293858ded42/contracts.proto#L77) from the generated contracts.
* `Topic` (`object`) - The serialized Topic Instance the Client receives Notification from.
* `Notification` (`object`) - Serialized Notification.

Example:

```json
{
    "Id": "0ddda545-cdbc-40f7-a42e-308c0a1d5e64",
    "TopicType": "ExampleApp.Core.Contracts.Projects.ProjectEmployeesAssignmentsTopic",
    "NotificationType": "ExampleApp.Core.Contracts.Projects.EmployeeAssignedToAssignmentDTO",
    "Topic": {
        "ProjectId": "project_01H9JQRCXQ2RP0BY9R4C7B6JM0"
    },
    "Notification": {
        "AssignmentId": "assignment_01HAKN813SDP5Z7N90GEP2KX05",
        "EmployeeId": "employee_01HAKN76BG45SN0GCNH801EX0D"
    }
}
```

### Received Notifications Topic Instance routing

The Client may have many established subscriptions to various Topic Instances and it may want to route received Notification basing on the Topic Instance it is coming from.
It must have implemented a deep equality comparer of the Topic Instances.
Then it should use it to compare `Topic` property from the received `NotificationEnvelope` across established subscriptions.

### Received Notifications type routing

The Client may want to route the received Notification basing on its type within its Topic Instance.
It should use the `NotificationType` property from the received `NotificationEnvelope` and match it with Notifications `tag` property from the generated contracts.
