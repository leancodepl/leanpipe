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

    private async Task ExecuteAsync(SubscriptionEnvelope envelope, string methodName)
    {
        var topic = deserializer.Deserialize(envelope);
        if (topic is null)
        {
            await NotifyResult(SubscriptionResult.Malformed(envelope.Id));
            return;
        }

        var handlerType = typeof(ISubscriptionHandler<>).MakeGenericType(new[] { topic.GetType() });
        var method =
            handlerType.GetMethod(methodName)
            ?? throw new NullReferenceException(
                $"No method named {methodName} declared on type {handlerType}."
            );
        var handler = services.GetRequiredService(handlerType);
        var result =
            method.Invoke(handler, new object[] { topic, this })
            ?? throw new InvalidOperationException(
                $"Cannot invoke method '{handlerType}.{method.Name}'."
            );
        await (Task)result;
        await NotifyResult(SubscriptionResult.Success(envelope.Id));
    }

    public Task SubscribeAsync(SubscriptionEnvelope envelope) =>
        ExecuteAsync(envelope, nameof(ISubscriptionHandler<ITopic>.OnSubscribed));

    public Task UnsubscribeAsync(SubscriptionEnvelope envelope) =>
        ExecuteAsync(envelope, nameof(ISubscriptionHandler<ITopic>.OnUnsubscribed));
}
