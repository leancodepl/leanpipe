using LeanCode.Contracts;

namespace LeanCode.LeanPipe.Tests;

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
