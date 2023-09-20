using LeanCode.Contracts;

namespace LeanCode.Pipe;

public interface ISubscriptionHandlerWrapper
{
    ValueTask OnSubscribedAsync(
        object topic,
        LeanPipeSubscriber leanPipeSubscriber,
        LeanPipeContext context
    );
    ValueTask OnUnsubscribedAsync(
        object topic,
        LeanPipeSubscriber leanPipeSubscriber,
        LeanPipeContext context
    );
}

public sealed class SubscriptionHandlerWrapper<TTopic> : ISubscriptionHandlerWrapper
    where TTopic : ITopic
{
    private readonly ISubscriptionHandler<TTopic> handler;

    public SubscriptionHandlerWrapper(ISubscriptionHandler<TTopic> handler)
    {
        this.handler = handler;
    }

    public ValueTask OnSubscribedAsync(
        object topic,
        LeanPipeSubscriber leanPipeSubscriber,
        LeanPipeContext context
    ) => handler.OnSubscribedAsync((TTopic)topic, leanPipeSubscriber, context);

    public ValueTask OnUnsubscribedAsync(
        object topic,
        LeanPipeSubscriber leanPipeSubscriber,
        LeanPipeContext context
    ) => handler.OnUnsubscribedAsync((TTopic)topic, leanPipeSubscriber, context);
}
