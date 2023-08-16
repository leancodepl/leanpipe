using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public interface ISubscriptionHandler<in TTopic>
    where TTopic : ITopic
{
    ValueTask OnSubscribedAsync(TTopic topic, LeanPipeSubscriber pipe, LeanPipeContext context);
    ValueTask OnUnsubscribedAsync(TTopic topic, LeanPipeSubscriber pipe, LeanPipeContext context);
}

public class KeyedSubscriptionHandler<TTopic> : ISubscriptionHandler<TTopic>
    where TTopic : ITopic
{
    private readonly ITopicController<TTopic> topicController;

    public KeyedSubscriptionHandler(ITopicController<TTopic> topicController)
    {
        this.topicController = topicController;
    }

    public async ValueTask OnSubscribedAsync(
        TTopic topic,
        LeanPipeSubscriber pipe,
        LeanPipeContext context
    )
    {
        var keys = await topicController.ToKeysAsync(topic, context);
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
        LeanPipeSubscriber pipe,
        LeanPipeContext context
    )
    {
        // with this implementation there is a problem of "higher level" groups:
        // if we subscribe to topic.something and topic.something.specific,
        // then we do not know when to unsubscribe from topic.something
        var keys = await topicController.ToKeysAsync(topic, context);
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
