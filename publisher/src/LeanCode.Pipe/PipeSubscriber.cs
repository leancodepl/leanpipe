using System.Text.Json;
using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.Pipe;

public class PipeSubscriber : Hub
{
    private readonly SubscriptionHandlerResolver resolver;
    private readonly IEnvelopeDeserializer deserializer;

    public PipeSubscriber(SubscriptionHandlerResolver resolver, IEnvelopeDeserializer deserializer)
    {
        this.resolver = resolver;
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

    private async Task ExecuteAsync(SubscriptionEnvelope envelope, OperationType type)
    {
        try
        {
            var httpContext =
                Context.GetHttpContext()
                ?? throw new InvalidOperationException(
                    "Connection is not associated with an HTTP request."
                );
            var topic =
                deserializer.Deserialize(envelope)
                ?? throw new InvalidOperationException("Cannot deserialize the topic.");
            var authorized = await PipeSecurity.CheckIfAuthorizedAsync(topic, httpContext);

            if (!authorized)
            {
                await NotifyResultAsync(envelope.Id, SubscriptionStatus.Unauthorized, type);
                return;
            }

            var context = new PipeContext(httpContext);
            var handler =
                resolver.FindSubscriptionHandler(topic.GetType())
                ?? throw new InvalidOperationException(
                    $"The resolver for topic {topic.GetType()} cannot be found."
                );
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
                $"Cannot deserialize topic {envelope.Topic.RootElement.GetRawText()} of type {envelope.TopicType}.",
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
