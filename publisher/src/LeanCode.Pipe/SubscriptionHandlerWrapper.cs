using LeanCode.Contracts;

namespace LeanCode.Pipe;

public interface ISubscriptionHandlerWrapper
{
    ValueTask OnSubscribedAsync(object topic, PipeSubscriber pipe, PipeContext context);
    ValueTask OnUnsubscribedAsync(object topic, PipeSubscriber pipe, PipeContext context);
}

public sealed class SubscriptionHandlerWrapper<TTopic> : ISubscriptionHandlerWrapper
    where TTopic : ITopic
{
    private readonly ISubscriptionHandler<TTopic> handler;

    public SubscriptionHandlerWrapper(ISubscriptionHandler<TTopic> handler)
    {
        this.handler = handler;
    }

    public ValueTask OnSubscribedAsync(object topic, PipeSubscriber pipe, PipeContext context) =>
        handler.OnSubscribedAsync((TTopic)topic, pipe, context);

    public ValueTask OnUnsubscribedAsync(object topic, PipeSubscriber pipe, PipeContext context) =>
        handler.OnUnsubscribedAsync((TTopic)topic, pipe, context);
}
