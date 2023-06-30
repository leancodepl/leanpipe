using System.Text.Json;
using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.LeanPipe;

public class LeanPipeSubscriber : Hub
{
    private readonly IServiceProvider services;
    private readonly IEnvelopeDeserializer deserializer;

    public LeanPipeSubscriber(IServiceProvider services, IEnvelopeDeserializer deserializer)
    {
        this.services = services;
        this.deserializer = deserializer;
    }

    private Task NotifyResult(Guid subscriptionId, SubscriptionStatus status, OperationType type) =>
        Clients.Caller.SendAsync(
            "subscriptionResult",
            new SubscriptionResult(subscriptionId, status, type)
        );

    private ISubscriptionHandlerWrapper GetSubscriptionHandler(Type topic)
    {
        var resolverType = typeof(ISubscriptionHandlerResolver<>).MakeGenericType(new[] { topic });
        var resolver =
            (ISubscriptionHandlerResolver<ITopic>)services.GetRequiredService(resolverType);
        var handler = resolver.FindSubscriptionHandler();
        return handler;
    }

    private async Task ExecuteAsync(
        SubscriptionEnvelope envelope,
        Func<ISubscriptionHandlerWrapper, ITopic, Task> action,
        OperationType type
    )
    {
        try
        {
            var topic = deserializer.Deserialize(envelope);
            var handler = GetSubscriptionHandler(topic.GetType());
            await action(handler, topic);
            await NotifyResult(envelope.Id, SubscriptionStatus.Success, type);
        }
        catch (JsonException error)
        {
            await NotifyResult(envelope.Id, SubscriptionStatus.Malformed, type);
            throw new InvalidOperationException(
                $"Cannot deserialize topic {envelope.Topic} of type {envelope.TopicType}.",
                error
            );
        }
        catch (Exception error)
        {
            await NotifyResult(envelope.Id, SubscriptionStatus.InternalServerError, type);
            throw new InvalidOperationException(
                $"Error on subscribing to topic {envelope.TopicType}.",
                error
            );
        }
    }

    public Task SubscribeAsync(SubscriptionEnvelope envelope) =>
        ExecuteAsync(
            envelope,
            (handler, topic) => handler.OnSubscribed(topic, this),
            OperationType.Subscribe
        );

    public Task UnsubscribeAsync(SubscriptionEnvelope envelope) =>
        ExecuteAsync(
            envelope,
            (handler, topic) => handler.OnUnsubscribed(topic, this),
            OperationType.Unsubscribe
        );
}
