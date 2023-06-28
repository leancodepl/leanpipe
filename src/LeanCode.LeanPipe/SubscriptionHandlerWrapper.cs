using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

/// <summary>
/// Marker interface, do not use directly.
/// </summary>
public interface ISubscriptionHandlerWrapper
{
    Task OnSubscribed(object topic, LeanPipeSubscriber pipe);
    Task OnUnsubscribed(object topic, LeanPipeSubscriber pipe);
}

internal sealed class SubscriptionHandlerWrapper<TTopic> : ISubscriptionHandlerWrapper
    where TTopic : ITopic
{
    private readonly ISubscriptionHandler<TTopic> handler;

    public SubscriptionHandlerWrapper(ISubscriptionHandler<TTopic> handler)
    {
        this.handler = handler;
    }

    public Task OnSubscribed(object topic, LeanPipeSubscriber pipe) =>
        handler.OnSubscribed((TTopic)topic, pipe);

    public Task OnUnsubscribed(object topic, LeanPipeSubscriber pipe) =>
        handler.OnUnsubscribed((TTopic)topic, pipe);
}
