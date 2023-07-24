using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

/// <summary>
/// Marker interface, do not use directly.
/// </summary>
public interface ISubscriptionHandlerWrapper
{
    Task OnSubscribedAsync(object topic, LeanPipeSubscriber pipe, LeanPipeContext context);
    Task OnUnsubscribedAsync(object topic, LeanPipeSubscriber pipe, LeanPipeContext context);
}

internal sealed class SubscriptionHandlerWrapper<TTopic> : ISubscriptionHandlerWrapper
    where TTopic : ITopic
{
    private readonly ISubscriptionHandler<TTopic> handler;

    public SubscriptionHandlerWrapper(ISubscriptionHandler<TTopic> handler)
    {
        this.handler = handler;
    }

    public Task OnSubscribedAsync(object topic, LeanPipeSubscriber pipe, LeanPipeContext context) =>
        handler.OnSubscribedAsync((TTopic)topic, pipe, context);

    public Task OnUnsubscribedAsync(
        object topic,
        LeanPipeSubscriber pipe,
        LeanPipeContext context
    ) => handler.OnUnsubscribedAsync((TTopic)topic, pipe, context);
}
