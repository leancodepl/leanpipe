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
    private readonly Serilog.ILogger logger = Serilog.Log.ForContext<SubscriptionExecutor>();

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
            var topic = deserializer.Deserialize(envelope);

            if (topic is null)
            {
                logger.Error("The topic type {TopicType} is unknown", envelope.TopicType);
                return SubscriptionStatus.Malformed;
            }

            var authorized = await security.CheckIfAuthorizedAsync(topic, context.User);

            if (!authorized)
            {
                logger.Warning(
                    "Connection is not authorized for {SubscriptionOperation} to topic {TopicType}",
                    type,
                    envelope.TopicType
                );
                return SubscriptionStatus.Unauthorized;
            }

            var handler =
                resolver.FindSubscriptionHandler(topic.GetType())
                ?? throw new InvalidOperationException(
                    $"The resolver for topic {envelope.TopicType} cannot be found."
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

            if (result)
            {
                logger.Debug(
                    "Subscription operation {SubscriptionOperation} on topic {TopicType} completed successfully",
                    type,
                    envelope.TopicType
                );
                return SubscriptionStatus.Success;
            }
            else
            {
                logger.Warning(
                    "Subscription operation {SubscriptionOperation} on topic {TopicType} completed successfully",
                    type,
                    envelope.TopicType
                );
                return SubscriptionStatus.Invalid;
            }
        }
        catch (JsonException e)
        {
            logger.Error(
                e,
                "The topic payload of type {TopicType} was malformed",
                envelope.TopicType
            );
            return SubscriptionStatus.Malformed;
        }
        catch (Exception e)
        {
            logger.Error(
                e,
                "{SubscriptionOperation} on topic {TopicType} failed",
                type,
                envelope.TopicType
            );
            return SubscriptionStatus.InternalServerError;
        }
    }
}
