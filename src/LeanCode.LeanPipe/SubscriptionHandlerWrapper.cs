using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

/// <summary>
/// Marker interface, do not use directly.
/// </summary>
public interface ISubscriptionHandlerWrapper
{
    Task OnSubscribedAsync(object topic, LeanPipeSubscriber pipe);
    Task OnUnsubscribedASync(object topic, LeanPipeSubscriber pipe);
}

internal sealed class SubscriptionHandlerWrapper<TTopic> : ISubscriptionHandlerWrapper
    where TTopic : ITopic
{
    private readonly ISubscriptionHandler<TTopic> handler;

    public SubscriptionHandlerWrapper(ISubscriptionHandler<TTopic> handler)
    {
        this.handler = handler;
    }

    public Task OnSubscribedAsync(object topic, LeanPipeSubscriber pipe) =>
        handler.OnSubscribedAsync((TTopic)topic, pipe);

    public Task OnUnsubscribedASync(object topic, LeanPipeSubscriber pipe) =>
        handler.OnUnsubscribedAsync((TTopic)topic, pipe);
}
