using LeanCode.Contracts;

namespace LeanCode.Pipe;

public interface ISubscriptionHandler<in TTopic>
    where TTopic : ITopic
{
    /// <returns>Whether subscription was correctly established.</returns>
    ValueTask<bool> OnSubscribedAsync(
        TTopic topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    );

    /// <returns>Whether subscription was correctly severed.</returns>
    ValueTask<bool> OnUnsubscribedAsync(
        TTopic topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    );
}

public class KeyedSubscriptionHandler<TTopic> : ISubscriptionHandler<TTopic>
    where TTopic : ITopic
{
    private readonly ISubscribingKeys<TTopic> subscribingKeys;

    public KeyedSubscriptionHandler(ISubscribingKeys<TTopic> subscribingKeys)
    {
        this.subscribingKeys = subscribingKeys;
    }

    public async ValueTask<bool> OnSubscribedAsync(
        TTopic topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    )
    {
        var keys = await subscribingKeys.GetForSubscribingAsync(topic, context);

        await subscribeContext.AddToGroupsAsync(keys, ct);

        return keys.Any();
    }

    public async ValueTask<bool> OnUnsubscribedAsync(
        TTopic topic,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    )
    {
        // With this implementation there is a problem of "higher level" groups:
        // if we subscribe to topic.something and topic.something.specific,
        // then we do not know when to unsubscribe from topic.something
        var keys = await subscribingKeys.GetForSubscribingAsync(topic, context);

        await subscribeContext.RemoveFromGroupsAsync(keys, ct);

        return keys.Any();
    }
}
