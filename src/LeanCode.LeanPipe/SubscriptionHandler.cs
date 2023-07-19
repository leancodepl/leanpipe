using LeanCode.Contracts;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

public interface ISubscriptionHandler<in TTopic>
    where TTopic : ITopic
{
    Task OnSubscribedAsync(TTopic topic, LeanPipeSubscriber pipe);
    Task OnUnsubscribedAsync(TTopic topic, LeanPipeSubscriber pipe);
}

public class KeyedSubscriptionHandler<TTopic> : ISubscriptionHandler<TTopic>
    where TTopic : ITopic
{
    private readonly ITopicController<TTopic> topicController;

    public KeyedSubscriptionHandler(ITopicController<TTopic> topicController)
    {
        this.topicController = topicController;
    }

    public async Task OnSubscribedAsync(TTopic topic, LeanPipeSubscriber pipe)
    {
        var context = new LeanPipeContext(
            pipe.Context.GetHttpContext() ?? new DefaultHttpContext()
        );
        var keys = await topicController.ToKeysAsync(
            topic,
            new(pipe.Context.GetHttpContext() ?? new DefaultHttpContext())
        );
        foreach (var key in keys)
        {
            await pipe.Groups.AddToGroupAsync(
                pipe.Context.ConnectionId,
                key,
                context.Context.RequestAborted
            );
        }
    }

    public async Task OnUnsubscribedAsync(TTopic topic, LeanPipeSubscriber pipe)
    {
        // with this implementation there is a problem of "higher level" groups:
        // if we subscribe to topic.something and topic.something.specific,
        // then we do not know when to unsubscribe from topic.something
        var context = new LeanPipeContext(
            pipe.Context.GetHttpContext() ?? new DefaultHttpContext()
        );
        var keys = await topicController.ToKeysAsync(topic, context);
        foreach (var key in keys)
        {
            await pipe.Groups.RemoveFromGroupAsync(
                pipe.Context.ConnectionId,
                key,
                context.Context.RequestAborted
            );
        }
    }
}
