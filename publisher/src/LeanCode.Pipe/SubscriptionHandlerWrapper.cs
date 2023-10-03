using LeanCode.Contracts;

namespace LeanCode.Pipe;

public interface ISubscriptionHandlerWrapper
{
    ValueTask<bool> OnSubscribedAsync(
        object topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    );

    ValueTask<bool> OnUnsubscribedAsync(
        object topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
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

    public ValueTask<bool> OnSubscribedAsync(
        object topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    ) => handler.OnSubscribedAsync((TTopic)topic, subscribeContext, context, ct);

    public ValueTask<bool> OnUnsubscribedAsync(
        object topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    ) => handler.OnUnsubscribedAsync((TTopic)topic, subscribeContext, context, ct);
}
