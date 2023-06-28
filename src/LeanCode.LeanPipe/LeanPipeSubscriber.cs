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

    private Task NotifyResult(SubscriptionResult result) =>
        Clients.Caller.SendAsync("subscriptionResult", result);

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
        Func<ISubscriptionHandlerWrapper, ITopic, Task> action
    )
    {
        var topic = deserializer.Deserialize(envelope);
        if (topic is null)
        {
            await NotifyResult(SubscriptionResult.Malformed(envelope.Id));
        }
        else
        {
            var handler = GetSubscriptionHandler(topic.GetType());
            await action(handler, topic);
            await NotifyResult(SubscriptionResult.Success(envelope.Id));
        }
    }

    public Task SubscribeAsync(SubscriptionEnvelope envelope) =>
        ExecuteAsync(envelope, (handler, topic) => handler.OnSubscribed(topic, this));

    public Task UnsubscribeAsync(SubscriptionEnvelope envelope) =>
        ExecuteAsync(envelope, (handler, topic) => handler.OnUnsubscribed(topic, this));
}
