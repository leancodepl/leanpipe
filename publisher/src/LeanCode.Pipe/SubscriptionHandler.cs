using LeanCode.Contracts;

namespace LeanCode.Pipe;

public interface ISubscriptionHandler<in TTopic>
    where TTopic : ITopic
{
    ValueTask OnSubscribedAsync(TTopic topic, PipeSubscriber pipe, PipeContext context);
    ValueTask OnUnsubscribedAsync(TTopic topic, PipeSubscriber pipe, PipeContext context);
}

public class KeyedSubscriptionHandler<TTopic> : ISubscriptionHandler<TTopic>
    where TTopic : ITopic
{
    private readonly ITopicKeys<TTopic> topicKeys;

    public KeyedSubscriptionHandler(ITopicKeys<TTopic> topicKeys)
    {
        this.topicKeys = topicKeys;
    }

    public async ValueTask OnSubscribedAsync(TTopic topic, PipeSubscriber pipe, PipeContext context)
    {
        var keys = await topicKeys.GetForSubscribingAsync(topic, context);
        foreach (var key in keys)
        {
            await pipe.Groups.AddToGroupAsync(
                pipe.Context.ConnectionId,
                key,
                pipe.Context.ConnectionAborted
            );
        }
    }

    public async ValueTask OnUnsubscribedAsync(
        TTopic topic,
        PipeSubscriber pipe,
        PipeContext context
    )
    {
        // with this implementation there is a problem of "higher level" groups:
        // if we subscribe to topic.something and topic.something.specific,
        // then we do not know when to unsubscribe from topic.something
        var keys = await topicKeys.GetForSubscribingAsync(topic, context);
        foreach (var key in keys)
        {
            await pipe.Groups.RemoveFromGroupAsync(
                pipe.Context.ConnectionId,
                key,
                pipe.Context.ConnectionAborted
            );
        }
    }
}
