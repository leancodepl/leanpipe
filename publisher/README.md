# LeanPipe Publisher

![Build & Release](https://github.com/leancodepl/leanpipe/actions/workflows/publisher_release.yml/badge.svg)
![Feedz](https://img.shields.io/feedz/v/leancode/public/LeanCode.Pipe)
[![codecov](https://codecov.io/gh/leancodepl/leanpipe/graph/badge.svg?token=LZIAEF100M)](https://codecov.io/gh/leancodepl/leanpipe)

Publisher part of the LeanPipe notification system that handles client subscription
and publishes notifications on the particular topics.

> [!NOTE]
> Standard LeanPipe requires the SignalR hub and notification publishing to happen
> in the same process, making it suitable for monolithic applications. For non-monolithic
> architectures (microservices, horizontally scaled services, multiple publishing services),
> use the [Funnel](src/Funnel/README.md) - a "we have Azure SignalR Services at home"
> solution that decouples SignalR connection handling from publishing services.

## Usage guide

### Defining Topics & Notifications in contracts

Define topics as DTOs implementing `ITopic` interface. Since clients subscribe to particular topic instances which must be distinguishable, one major requirement regarding topic DTOs appears:

> [!IMPORTANT]
> Defined topics must only use properties that later could be compared using deep equality.

If the topic is to require permissions, use [authorize attributes](https://github.com/leancodepl/contractsgenerator/blob/main/src/LeanCode.Contracts/Security/AuthorizeWhenAttribute.cs), as you would in your CQRS objects.

Then, define notifications as simple DTOs.
In order to indicate which notifications can be published to topic, implement `IProduceNotification<TNotification>` in the topic.

### LeanPipe Topics vs SignalR Groups

Although we strive for the developer experience to feel frictionless and magical, we need to know a bit about SignalR groups.

That’s because topics operate on the [SignalR groups](https://learn.microsoft.com/en-us/aspnet/core/signalr/groups?view=aspnetcore-10.0) underneath, which are quite limited.
You can add a connection to the group, you can remove it, and you can send a message to the group.
You cannot list them, check their connections, even check if they exist themselves.
Those properties are also topics instances properties.

However, one topic instance may work on multiple groups, which gives some flexibility to the topic developer.
For that to work, one must implement a `ISubscribingKeys<TTopic>` and `IPublishingKeys<TTopic, TNotification>` for each topic and it’s notification, which is responsible for mapping a topic instances and notifications to groups.
It should be easiest to maintain if all of those singular topic interfaces implementations would be in a single class.
That mapping will be used every time a client subscribes, unsubscribes or backend wants to publish a notification.

Consider prefixing generated keys with with a prefix unique per topic, in order to dodge some inter-topic keys clashes
(it could make user unsubscribe from one topic instance while the client wanted to unsubscribe from just the other topic instance).

### Publishing notifications

Publishing from the publishers POV is quite simple really.
Just inject a `ILeanPipePublisher<TTopic>` in the handler of your choice, where `TTopic` is type of topic you’d like to publish to, construct a notification from the topic notification pool and the topic instance, `publisher.PublishAsync(topic, notification)` and you’re good to go.

### Examples

This library is designed having in mind use cases which would fall into two groups:

1. Basic topic
2. Dynamic topic

#### Basic topic example

It suffices use cases which are very simple, however also very common (so we expect at least).
Let’s imagine a client would like to know about updates of a single, distinguishable entity - an auction, an import process, a match.
A something that a client would be interested to know about on just a single page in their app probably.
Let’s stick to the auction in this example.
The topic would be defined as such:

```csharp
public class AuctionNotifications : ITopic, IProduceNotification<BidPlaced>, IProduceNotification<ItemSold>
{
    public string AuctionId { get; set; }
}

public class BidPlaced
{
    public int Amount { get; set; }
    public string User { get; set; }
}

public class ItemSold
{
    public string Buyer { get; set; }
}
```

For that basic scenario to work we expose you an abstract class which needs just a single method implementation - `BasicTopicKeys<TTopic, [TNotification1, ...]>` with missing method `IEnumerable<string> Get(TTopic topic)`.
Its implementation will be elementary:

```csharp
AuctionNotificationsKeysFactory : BasicTopicKeys<AuctionNotifications, BidPlaced, ItemSold>
{
  public IEnumerable<string> Get(AuctionNotifications topic)
  {
    return new[] { topic.AuctionId.ToString() };
  }
}
```

And that’s all your clients may subscribe/unsubscribe to `AuctionNotifications` and you can publish as much as you want.

#### Dynamic topic example

Okay, this would probably a little bit more exotic, but still useful.
Let’s think about something a user might want to know about, but it could be different for each users, like `FollowedMatchesNotifications`, `MyAuctionsNotifications`, etc.
From the apps POV those topics would probably be useful in a lot of pages, possibly even everywhere on the app so the client could subscribe to on the app start.
Let’s stick to the `MyAuctionsNotifications` topic.
It could look quite like:

```csharp
public class MyAuctionsNotifications : ITopic, IProduceNotification<BidPlaced>, IProduceNotification<ItemSold>
{ }

public class BidPlaced
{
    public string AuctionId { get; set; }
    public int Amount { get; set; }
    public string User { get; set; }
}

public class ItemSold
{
    public string AuctionId { get; set; }
    public string Buyer { get; set; }
}
```

This is a bit different from the example above, now we need context of the concrete auction in each notification.
Fret not, we’ve got you covered my dear future topic implementer.
However now the `BasicTopicKeys` will be of no use to us - we need to go deeper, we need to have a class that implements a `IPublishingKeys<TTopic, TNotication>` for each type of notification from the topics pool,
which will be equivalent to providing implementation for `ValueTask<IEnumerable<string>> GetForSubscribingAsync(TTopic topic, LeanPipeContext context)` and each of `ValueTask<IEnumerable<string>> GetForPublishingAsync(TTopic topic, TNotication notification)`.
This is how it could look like:

```csharp
MyAuctionsNotificationsKeys : IPublishingKeys<MyAuctionsNotifications, BidPlaced>, IPublishingKeys<MyAuctionsNotifications, ItemSold>
{
  private DbContext dbContext;

  public async ValueTask<IEnumerable<string>> GetForSubscribingAsync(Auction topic, LeanPipeContext context)
  {
    var userId = context.HttpContext.GetUserId();

    var usersAuctions = await dbContext.Auctions
      .Where(a => a.SellerId == userId)
      .Select(a => a.Id)
      .ToListAsync(context.HttpContext.RequestAborted);

    return usersAuctions.Select(a => a.ToString());
  }

  public async ValueTask<IEnumerable<string>> GetForPublishingAsync(Auction topic, BidPlaced notification)
  {
    return Task.FromResult(new[] { notification.AuctionId.ToString() });
  }

  public async ValueTask<IEnumerable<string>> GetForPublishingAsync(Auction topic, ItemSold notification)
  {
    return Task.FromResult(new[] { notification.AuctionId.ToString() });
  }
}
```

That’s a little bit more than in the basic example, but also works!

> [!WARNING]
> In this model the entity list is a snapshot from the subscription time.
> Should one want to have an updated snapshot they should resubscribe again.
