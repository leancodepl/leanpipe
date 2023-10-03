using System.Text.Json;
using LeanCode.Contracts;

namespace LeanCode.Pipe;

public interface ISubscriptionExecutor
{
    Task<SubscriptionStatus> ExecuteAsync(
        SubscriptionEnvelope envelope,
        OperationType type,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    );
}

public class SubscriptionExecutor : ISubscriptionExecutor
{
    private readonly SubscriptionHandlerResolver resolver;
    private readonly IEnvelopeDeserializer deserializer;
    private readonly LeanPipeSecurity security;

    public SubscriptionExecutor(
        SubscriptionHandlerResolver resolver,
        IEnvelopeDeserializer deserializer,
        LeanPipeSecurity security
    )
    {
        this.resolver = resolver;
        this.deserializer = deserializer;
        this.security = security;
    }

    public async Task<SubscriptionStatus> ExecuteAsync(
        SubscriptionEnvelope envelope,
        OperationType type,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    )
    {
        try
        {
            var topic =
                deserializer.Deserialize(envelope)
                ?? throw new InvalidOperationException("Cannot deserialize the topic.");

            var authorized = await security.CheckIfAuthorizedAsync(topic, context.User);

            if (!authorized)
            {
                return SubscriptionStatus.Unauthorized;
            }

            var handler =
                resolver.FindSubscriptionHandler(topic.GetType())
                ?? throw new InvalidOperationException(
                    $"The resolver for topic {topic.GetType()} cannot be found."
                );

            bool result;

            if (type == OperationType.Subscribe)
            {
                result = await handler.OnSubscribedAsync(topic, subscribeContext, context, ct);
            }
            else
            {
                result = await handler.OnUnsubscribedAsync(topic, subscribeContext, context, ct);
            }

            return result ? SubscriptionStatus.Success : SubscriptionStatus.Invalid;
        }
        catch (JsonException e)
        {
            return SubscriptionStatus.Malformed;

            // TODO: Log error
            // throw new InvalidOperationException(
            //     $"Cannot deserialize topic {envelope.Topic.RootElement.GetRawText()} of type {envelope.TopicType}.",
            //     e
            // );
        }
        catch (Exception e)
        {
            return SubscriptionStatus.InternalServerError;

            // TODO: Log error
            throw new InvalidOperationException(
                $"Error on subscribing to topic {envelope.TopicType}.",
                e
            );
        }
    }
}
