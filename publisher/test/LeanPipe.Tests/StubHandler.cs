using LeanCode.Contracts;

namespace LeanPipe.Tests;

public class StubHandler<T> : ISubscriptionHandler<T>
    where T : ITopic
{
    public bool SubscribedCalled { get; private set; }
    public bool UnsubscribedCalled { get; private set; }

    public ValueTask OnSubscribedAsync(T topic, LeanPipeSubscriber pipe, LeanPipeContext context)
    {
        SubscribedCalled = true;
        return new();
    }

    public ValueTask OnUnsubscribedAsync(T topic, LeanPipeSubscriber pipe, LeanPipeContext context)
    {
        UnsubscribedCalled = true;
        return new();
    }
}

public class StubHandler : StubHandler<Topic1> { }

public class DummyKeys<T> : ITopicKeys<T>
    where T : ITopic
{
    public ValueTask<IEnumerable<string>> GetAsync(T topic, LeanPipeContext context)
    {
        return new(Enumerable.Empty<string>());
    }
}

public class TopicWithAllKeysKeys
    : DummyKeys<TopicWithAllKeys>,
        INotificationKeys<TopicWithAllKeys, Notification1>,
        INotificationKeys<TopicWithAllKeys, Notification2>
{
    public ValueTask<IEnumerable<string>> GetAsync(
        TopicWithAllKeys topic,
        Notification1 notification,
        LeanPipeContext context
    )
    {
        return new(Array.Empty<string>());
    }

    public ValueTask<IEnumerable<string>> GetAsync(
        TopicWithAllKeys topic,
        Notification2 notification,
        LeanPipeContext context
    )
    {
        return new(Array.Empty<string>());
    }
}