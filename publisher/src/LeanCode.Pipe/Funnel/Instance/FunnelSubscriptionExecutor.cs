using LeanCode.Contracts;
using MassTransit;

namespace LeanCode.Pipe.Funnel.Instance;

public class FunnelSubscriptionExecutor : ISubscriptionExecutor
{
    private readonly Serilog.ILogger logger = Serilog.Log.ForContext<FunnelSubscriptionExecutor>();

    private readonly IBus bus;
    private readonly IEndpointNameFormatter? endpointNameFormatter;

    public FunnelSubscriptionExecutor(IBus bus)
    {
        this.bus = bus;
    }

    public FunnelSubscriptionExecutor(IBus bus, IEndpointNameFormatter endpointNameFormatter)
    {
        this.bus = bus;
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
        var endpoint = FunnelledSubscriberEndpointNameProvider.GetName(envelope.TopicType);

        if (endpointNameFormatter is not null)
        {
            endpoint = endpointNameFormatter.SanitizeName(endpoint);
        }

        // For RabbitMQ use `exchange`s to get instant errors if no queue doesn't exist, can't do that in other brokers.
        // https://masstransit.io/documentation/concepts/producers#supported-address-schemes
        var endpointPrefix = bus.Topology is IRabbitMqBusTopology ? "exchange" : "queue";

        var endpointUri = new Uri($"{endpointPrefix}:{endpoint}");

        var subscriberRequestClient = bus.CreateRequestClient<ExecuteTopicsSubscriptionPipeline>(
            endpointUri
        );

        try
        {
            var response = await subscriberRequestClient.GetResponse<SubscriptionPipelineResult>(
                new(envelope, type, context),
                rpc =>
                {
                    rpc.UseExecute(ctx =>
                    {
                        if (ctx is RabbitMqSendContext rctx)
                        {
                            // Don't create the exchange - it's responsibility of the service.
                            rctx.Mandatory = true;
                        }
                    });
                },
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
