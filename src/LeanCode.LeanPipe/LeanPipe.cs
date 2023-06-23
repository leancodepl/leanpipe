using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

public class LeanPipe : Hub
{
    private readonly IServiceProvider services;

    public LeanPipe(IServiceProvider services)
    {
        this.services = services;
    }

    private ISubscriptionHandler<ITopic> GetSubscriptionHandler(Type topicType)
    {
        var handlerType = typeof(ISubscriptionHandler<>).MakeGenericType(new[] { topicType });
        dynamic handler =
            services.GetService(handlerType)
            ?? throw new NullReferenceException(
                $"Could not retrieve 'ISubscriptionHandler<{topicType.Name}>' service."
            );
        return handler;
    }

    public Task SubscribeAsync(ITopic topic)
    {
        var topicType = topic.GetType();
        var handler = GetSubscriptionHandler(topicType);
        return handler.OnSubscribed(topic, this);
    }

    public Task UnsubscribeAsync(ITopic topic)
    {
        var topicType = topic.GetType();
        var handler = GetSubscriptionHandler(topicType);
        return handler.OnUnsubscribed(topic, this);
    }
}
