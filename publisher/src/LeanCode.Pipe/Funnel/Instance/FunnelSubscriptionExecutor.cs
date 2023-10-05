using LeanCode.Contracts;
using MassTransit;

namespace LeanCode.Pipe.Funnel.Instance;

public class FunnelSubscriptionExecutor : ISubscriptionExecutor
{
    private readonly Serilog.ILogger logger = Serilog.Log.ForContext<FunnelSubscriptionExecutor>();

    private readonly IEndpointNameFormatter endpointNameFormatter;
    private readonly IBus bus;

    public FunnelSubscriptionExecutor(IEndpointNameFormatter endpointNameFormatter, IBus bus)
    {
        this.endpointNameFormatter = endpointNameFormatter;
        this.bus = bus;
    }

    public async Task<SubscriptionStatus> ExecuteAsync(
        SubscriptionEnvelope envelope,
        OperationType type,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    )
    {
        var endpoint = endpointNameFormatter.SanitizeName(
            FunnelledSubscriberEndpointNameProvider.GetName(envelope.TopicType)
        );

        var endpointPrefix = bus.Topology is IRabbitMqBusTopology ? "exchange" : "topic";

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
