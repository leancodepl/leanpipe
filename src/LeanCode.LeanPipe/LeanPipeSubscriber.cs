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

    public async Task Subscribe(SubscriptionEnvelope envelope)
    {
        await ExecuteAsync(envelope, OperationType.Subscribe);
    }

    public async Task Unsubscribe(SubscriptionEnvelope envelope)
    {
        await ExecuteAsync(envelope, OperationType.Unsubscribe);
    }

    private async Task NotifyResultAsync(
        Guid subscriptionId,
        SubscriptionStatus status,
        OperationType type
    )
    {
        await Clients.Caller.SendAsync(
            "subscriptionResult",
            new SubscriptionResult(subscriptionId, status, type)
        );
    }

    private ISubscriptionHandlerWrapper GetSubscriptionHandler(Type topic)
    {
        var resolverType = typeof(ISubscriptionHandlerResolver<>).MakeGenericType(new[] { topic });
        var resolver =
            (ISubscriptionHandlerResolver<ITopic>)services.GetRequiredService(resolverType);
        var handler = resolver.FindSubscriptionHandler();
        return handler;
    }

    private async Task ExecuteAsync(SubscriptionEnvelope envelope, OperationType type)
    {
        try
        {
            var httpContext =
                Context.GetHttpContext()
                ?? throw new InvalidOperationException(
                    "Connection is not associated with an HTTP request."
                );
            var topic = deserializer.Deserialize(envelope);
            var authorized = await LeanPipeSecurity.CheckIfAuthorizedAsync(topic, httpContext);

            if (!authorized)
            {
                await NotifyResultAsync(envelope.Id, SubscriptionStatus.Unauthorized, type);
                return;
            }

            var context = new LeanPipeContext(httpContext);
            var handler = GetSubscriptionHandler(topic.GetType());
            if (type == OperationType.Subscribe)
            {
                await handler.OnSubscribedAsync(topic, this, context);
            }
            else
            {
                await handler.OnUnsubscribedAsync(topic, this, context);
            }
            await NotifyResultAsync(envelope.Id, SubscriptionStatus.Success, type);
        }
        catch (JsonException e)
        {
            await NotifyResultAsync(envelope.Id, SubscriptionStatus.Malformed, type);
            throw new InvalidOperationException(
                $"Cannot deserialize topic {envelope.Topic} of type {envelope.TopicType}.",
                e
            );
        }
        catch (Exception e)
        {
            await NotifyResultAsync(envelope.Id, SubscriptionStatus.InternalServerError, type);
            throw new InvalidOperationException(
                $"Error on subscribing to topic {envelope.TopicType}.",
                e
            );
        }
    }
}
