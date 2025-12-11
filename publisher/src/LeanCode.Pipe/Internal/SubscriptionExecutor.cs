using System.Diagnostics.CodeAnalysis;
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
    private readonly ITopicExtractor topicExtractor;
    private readonly LeanPipeSecurity security;

    public SubscriptionExecutor(
        SubscriptionHandlerResolver resolver,
        ITopicExtractor topicExtractor,
        LeanPipeSecurity security
    )
    {
        this.resolver = resolver;
        this.topicExtractor = topicExtractor;
        this.security = security;
    }

    [SuppressMessage(
        "Design",
        "CA1031:Do not catch general exception types",
        Justification = "Must return, part of the pipeline."
    )]
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
            var topic = ExtractTopic(envelope);

            if (topic is null)
            {
                return SubscriptionStatus.Malformed;
            }

            var authorized = await AuthorizeAsync(topic, envelope, type, context, ct);

            if (!authorized)
            {
                return SubscriptionStatus.Unauthorized;
            }

            var result = await HandleAsync(topic, envelope, type, context, subscribeContext, ct);

            return result ? SubscriptionStatus.Success : SubscriptionStatus.Invalid;
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

    private ITopic? ExtractTopic(SubscriptionEnvelope envelope)
    {
        try
        {
            var topic = topicExtractor.Extract(envelope);

            if (topic is null)
            {
                logger.Error("The topic type {TopicType} is unknown", envelope.TopicType);
            }

            return topic;
        }
        catch (JsonException e)
        {
            logger.Error(
                e,
                "The topic payload of type {TopicType} was malformed",
                envelope.TopicType
            );

            return null;
        }
    }

    private async Task<bool> AuthorizeAsync(
        ITopic topic,
        SubscriptionEnvelope envelope,
        OperationType type,
        LeanPipeContext context,
        CancellationToken ct
    )
    {
        var authorized = await security.CheckIfAuthorizedAsync(topic, context.User, ct);

        if (!authorized)
        {
            logger.Warning(
                "Connection is not authorized for {SubscriptionOperation} to topic {TopicType}",
                type,
                envelope.TopicType
            );
        }

        return authorized;
    }

    private async Task<bool> HandleAsync(
        ITopic topic,
        SubscriptionEnvelope envelope,
        OperationType type,
        LeanPipeContext context,
        ISubscribeContext subscribeContext,
        CancellationToken ct
    )
    {
        var handler =
            resolver.FindSubscriptionHandler(topic.GetType())
            ?? throw new InvalidOperationException(
                $"The resolver for topic {envelope.TopicType} cannot be found."
            );

        var result = await HandleSubscriptionOperationAsync();

        if (result)
        {
            logger.Information(
                "Subscription operation {SubscriptionOperation} on topic {TopicType} completed successfully",
                type,
                envelope.TopicType
            );
        }
        else
        {
            logger.Warning(
                "Subscription operation {SubscriptionOperation} on topic {TopicType} was invalid",
                type,
                envelope.TopicType
            );
        }

        return result;

        ValueTask<bool> HandleSubscriptionOperationAsync()
        {
            return type == OperationType.Subscribe
                ? handler.OnSubscribedAsync(topic, subscribeContext, context, ct)
                : handler.OnUnsubscribedAsync(topic, subscribeContext, context, ct);
        }
    }
}
