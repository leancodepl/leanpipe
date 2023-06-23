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

    // very much improvised, no idea if this will work as I think it would (probably not)
    // TODO: test if this works
    private (ITopic, ISubscriptionHandler<ITopic>) DeserializeEnvelope(
        SubscriptionEnvelope envelope
    )
    {
        var topicType =
            Type.GetType(envelope.TopicType)
            ?? throw new NullReferenceException($"Topic type '{envelope.TopicType}' unknown.");
        dynamic topic = Convert.ChangeType(envelope.Topic, topicType);
        var handler = GetSubscriptionHandler(topicType);
        return (topic, handler);
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

    public Task SubscribeAsync(SubscriptionEnvelope envelope)
    {
        var (topic, handler) = DeserializeEnvelope(envelope);
        return handler.OnSubscribed(topic, this);
    }

    public Task UnsubscribeAsync(SubscriptionEnvelope envelope)
    {
        var (topic, handler) = DeserializeEnvelope(envelope);
        return handler.OnUnsubscribed(topic, this);
    }
}
