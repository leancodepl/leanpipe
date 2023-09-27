using LeanCode.Contracts;

namespace LeanCode.Pipe;

public interface ISubscriptionHandler<in TTopic>
    where TTopic : ITopic
{
    /// <returns>Whether subscription was correctly established.</returns>
    ValueTask<bool> OnSubscribedAsync(
        TTopic topic,
        LeanPipeSubscriber leanPipeSubscriber,
        LeanPipeContext context
    );

    /// <returns>Whether subscription was correctly severed.</returns>
    ValueTask<bool> OnUnsubscribedAsync(
        TTopic topic,
        LeanPipeSubscriber leanPipeSubscriber,
        LeanPipeContext context
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
        LeanPipeSubscriber leanPipeSubscriber,
        LeanPipeContext context
    )
    {
        var keys = await subscribingKeys.GetForSubscribingAsync(topic, context);

        var tasks = keys.Select(
            key =>
                leanPipeSubscriber.Groups.AddToGroupAsync(
                    leanPipeSubscriber.Context.ConnectionId,
                    key,
                    leanPipeSubscriber.Context.ConnectionAborted
                )
        );

        await Task.WhenAll(tasks);

        return keys.Any();
    }

    public async ValueTask<bool> OnUnsubscribedAsync(
        TTopic topic,
        LeanPipeSubscriber leanPipeSubscriber,
        LeanPipeContext context
    )
    {
        // With this implementation there is a problem of "higher level" groups:
        // if we subscribe to topic.something and topic.something.specific,
        // then we do not know when to unsubscribe from topic.something
        var keys = await subscribingKeys.GetForSubscribingAsync(topic, context);

        var tasks = keys.Select(
            key =>
                leanPipeSubscriber.Groups.RemoveFromGroupAsync(
                    leanPipeSubscriber.Context.ConnectionId,
                    key,
                    leanPipeSubscriber.Context.ConnectionAborted
                )
        );

        await Task.WhenAll(tasks);

        return keys.Any();
    }
}
