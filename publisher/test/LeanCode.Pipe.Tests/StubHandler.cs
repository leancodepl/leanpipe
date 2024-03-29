using LeanCode.Contracts;

namespace LeanCode.Pipe.Tests;

public class StubHandler<T> : ISubscriptionHandler<T>
    where T : ITopic
{
    public bool SubscribedCalled { get; private set; }
    public bool UnsubscribedCalled { get; private set; }

    public ValueTask<bool> OnSubscribedAsync(
        T topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    )
    {
        SubscribedCalled = true;
        return ValueTask.FromResult(true);
    }

    public ValueTask<bool> OnUnsubscribedAsync(
        T topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    )
    {
        UnsubscribedCalled = true;
        return ValueTask.FromResult(true);
    }
}

public class StubHandler : StubHandler<Topic1> { }

public class DummyKeys<T> : ISubscribingKeys<T>
    where T : ITopic
{
    public ValueTask<IEnumerable<string>> GetForSubscribingAsync(T topic, LeanPipeContext context)
    {
        return new(Enumerable.Empty<string>());
    }

    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        T topic,
        CancellationToken ct = default
    )
    {
        return new(Enumerable.Empty<string>());
    }
}

public class TopicWithAllKeysKeys
    : DummyKeys<TopicWithAllKeys>,
        IPublishingKeys<TopicWithAllKeys, Notification1>,
        IPublishingKeys<TopicWithAllKeys, Notification2>
{
    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TopicWithAllKeys topic,
        Notification1 notification,
        CancellationToken ct = default
    )
    {
        return new(Array.Empty<string>());
    }

    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TopicWithAllKeys topic,
        Notification2 notification,
        CancellationToken ct = default
    )
    {
        return new(Array.Empty<string>());
    }
}
