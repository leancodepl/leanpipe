# @leancodepl/pipe

A TypeScript client for subscribing to real-time data streams using LeanPipe. Manages topic subscriptions with automatic reconnection and type-safe notification handling.

## Installation

```bash
npm install @leancodepl/pipe
```

## API

### `Pipe(url, options)`

Creates a new pipe instance for managing topic subscriptions.

**Parameters:**
- `url` (string) - LeanPipe publisher URL to connect to
- `options` (IHttpConnectionOptions, optional) - Optional connection configuration

**Returns:** Pipe instance

### `pipe.topic(topicType, topic)`

Subscribes to a topic and returns an observable of notifications.

**Parameters:**
- `topicType` (string) - Type identifier for the topic
- `topic` (unknown) - Topic parameters or filters

**Returns:** Observable<NotificationsUnion<TNotifications>> - Observable that emits notification tuples [NotificationType, Notification]

**Throws:** `Error` - When subscription fails or times out after 3 seconds

### `NotificationsUnion<T>`

Union type representing all possible notification tuples for a given notification mapping.

**Generic Parameters:**
- `T` (Record<string, unknown>) - Record mapping notification types to their payload types

### `SubscriptionState`

Represents the state of a topic subscription.

**Properties:**
- `topicType` (string) - Type identifier for the topic
- `topic` (unknown) - Topic parameters or filters
- `notifications$` (Observable<unknown>) - Observable of notifications for this topic

### `NotificationEnvelope`

Envelope containing notification data from the server.

**Properties:**
- `Id` (string) - Unique notification identifier
- `TopicType` (string) - Type identifier for the topic
- `NotificationType` (string) - Type of notification
- `Topic` (unknown) - Topic parameters or filters
- `Notification` (unknown) - Notification payload

### `SubscriptionResult`

Result of a subscription operation.

**Properties:**
- `SubscriptionId` (string) - Unique subscription identifier
- `Status` (SubscriptionStatus) - Status of the subscription operation
- `Type` (OperationType) - Type of operation performed

### `SubscriptionStatus`

Status codes for subscription operations.

**Values:**
- `Success` (0) - Subscription successful
- `Unauthorized` (1) - User not authorized for topic
- `Malformed` (2) - Invalid subscription request
- `Invalid` (3) - Topic or parameters invalid
- `InternalServerError` (4) - Server error occurred

### `OperationType`

Types of operations that can be performed on subscriptions.

**Values:**
- `Subscribe` (0) - Subscribe to a topic
- `Unsubscribe` (1) - Unsubscribe from a topic

## Usage Examples

### Basic Topic Subscription

```typescript
import { Pipe } from "@leancodepl/pipe";

const pipe = new Pipe({ 
  url: "https://api.example.com/leanpipe" 
});

const notifications$ = pipe.topic("User", { userId: "123" });

notifications$.subscribe(([type, data]) => {
  console.log(`Received ${type}:`, data);
});
```

### Type-Safe Notifications

```typescript
import { Pipe } from "@leancodepl/pipe";

interface UserNotifications {
  UserUpdated: { id: string; name: string; email: string };
  UserDeleted: { id: string };
  UserCreated: { id: string; name: string };
}

const pipe = new Pipe({ url: "https://api.example.com/leanpipe" });

const userNotifications$ = pipe.topic<UserNotifications>("User", { 
  organizationId: "org-123" 
});

userNotifications$.subscribe(([type, data]) => {
  switch (type) {
    case "UserUpdated":
      console.log("User updated:", data.name, data.email);
      break;
    case "UserDeleted":
      console.log("User deleted:", data.id);
      break;
    case "UserCreated":
      console.log("User created:", data.name);
      break;
  }
});
```

### With Authentication

```typescript
import { Pipe } from "@leancodepl/pipe";

const pipe = new Pipe({ 
  url: "https://api.example.com/leanpipe",
  options: { 
    accessTokenFactory: () => localStorage.getItem("token") 
  }
});

const notifications$ = pipe.topic("Project", { projectId: "proj-456" });

notifications$.subscribe(([type, data]) => {
  console.log(`Project ${type}:`, data);
});
```

### Multiple Topic Subscriptions

```typescript
import { Pipe } from "@leancodepl/pipe";

const pipe = new Pipe({ url: "https://api.example.com/leanpipe" });

// Subscribe to user notifications
const userNotifications$ = pipe.topic("User", { userId: "123" });

// Subscribe to project notifications
const projectNotifications$ = pipe.topic("Project", { projectId: "456" });

// Handle both streams
userNotifications$.subscribe(([type, data]) => {
  console.log("User notification:", type, data);
});

projectNotifications$.subscribe(([type, data]) => {
  console.log("Project notification:", type, data);
});
```