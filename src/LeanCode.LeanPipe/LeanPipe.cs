using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

public class LeanPipe : Hub
{
    private readonly IServiceProvider services;
    private readonly IEnvelopeDeserializer deserializer;

    public LeanPipe(IServiceProvider services, IEnvelopeDeserializer deserializer)
    {
        this.services = services;
        this.deserializer = deserializer;
    }

    private (ITopic, ISubscriptionHandler<ITopic>) DeserializeEnvelope(
        SubscriptionEnvelope envelope
    )
    {
        var topic = deserializer.Deserialize(envelope);
        var handler = GetSubscriptionHandler(topic.GetType());
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
