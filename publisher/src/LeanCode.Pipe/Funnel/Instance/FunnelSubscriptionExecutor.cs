using LeanCode.Contracts;
using MassTransit;

namespace LeanCode.Pipe.Funnel.Instance;

public class FunnelSubscriptionExecutor : ISubscriptionExecutor
{
    private readonly Serilog.ILogger logger = Serilog.Log.ForContext<FunnelSubscriptionExecutor>();

    private readonly IScopedClientFactory scopedClientFactory;
    private readonly IRequestClient<CheckTopicRecognized> checkTopicRecognizedRequestClient;
    private readonly IEndpointNameFormatter? endpointNameFormatter;

    public FunnelSubscriptionExecutor(
        IScopedClientFactory scopedClientFactory,
        IRequestClient<CheckTopicRecognized> checkTopicRecognizedRequestClient
    )
    {
        this.scopedClientFactory = scopedClientFactory;
        this.checkTopicRecognizedRequestClient = checkTopicRecognizedRequestClient;
    }

    public FunnelSubscriptionExecutor(
        IScopedClientFactory scopedClientFactory,
        IRequestClient<CheckTopicRecognized> checkTopicRecognizedRequestClient,
        IEndpointNameFormatter endpointNameFormatter
    )
    {
        this.scopedClientFactory = scopedClientFactory;
        this.checkTopicRecognizedRequestClient = checkTopicRecognizedRequestClient;
        this.endpointNameFormatter = endpointNameFormatter;
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
            await checkTopicRecognizedRequestClient.GetResponse<TopicRecognized>(
                new(envelope.TopicType),
                ct
            );
        }
        catch (RequestTimeoutException e)
        {
            logger.Warning(e, "Subscription to unrecognized topic attempted");
            return SubscriptionStatus.Malformed;
        }

        var endpoint = FunnelledSubscriberEndpointNameProvider.GetName(envelope.TopicType);

        if (endpointNameFormatter is not null)
        {
            endpoint = endpointNameFormatter.SanitizeName(endpoint);
        }

        var endpointUri = new Uri($"queue:{endpoint}");

        var subscriberRequestClient =
            scopedClientFactory.CreateRequestClient<ExecuteTopicsSubscriptionPipeline>(endpointUri);

        try
        {
            var response = await subscriberRequestClient.GetResponse<SubscriptionPipelineResult>(
                new(envelope, type, context),
                ct
            );

            var msg = response.Message;

            if (msg.Status == SubscriptionStatus.Success)
            {
                if (type == OperationType.Subscribe)
                {
                    await subscribeContext.AddToGroupsAsync(msg.GroupKeys, ct);
                }
                else
                {
                    await subscribeContext.RemoveFromGroupsAsync(msg.GroupKeys, ct);
                }
            }

            return msg.Status;
        }
        catch (Exception e)
        {
            logger.Error(e, "LeanPipe subscription executor failed");
            return SubscriptionStatus.InternalServerError;
        }
    }
}
