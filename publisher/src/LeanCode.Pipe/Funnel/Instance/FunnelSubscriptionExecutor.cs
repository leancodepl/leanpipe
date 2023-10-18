using LeanCode.Contracts;
using LeanCode.Pipe.Funnel.FunnelledService;
using MassTransit;
using MassTransit.Clients;

namespace LeanCode.Pipe.Funnel.Instance;

public class FunnelSubscriptionExecutor : ISubscriptionExecutor
{
    private readonly Serilog.ILogger logger = Serilog.Log.ForContext<FunnelSubscriptionExecutor>();

    private readonly IBus bus;
    private readonly IRequestClient<CheckTopicRecognized> checkTopicRecognizedRequestClient;
    private readonly IEndpointNameFormatter? endpointNameFormatter;

    public FunnelSubscriptionExecutor(
        IBus bus,
        IRequestClient<CheckTopicRecognized> checkTopicRecognizedRequestClient
    )
    {
        this.bus = bus;
        this.checkTopicRecognizedRequestClient = checkTopicRecognizedRequestClient;
    }

    public FunnelSubscriptionExecutor(
        IBus bus,
        IRequestClient<CheckTopicRecognized> checkTopicRecognizedRequestClient,
        IEndpointNameFormatter endpointNameFormatter
    )
    {
        this.bus = bus;
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

        var subscriberRequestClient = bus.CreateRequestClient<ExecuteTopicsSubscriptionPipeline>(
            endpointUri
        );

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
