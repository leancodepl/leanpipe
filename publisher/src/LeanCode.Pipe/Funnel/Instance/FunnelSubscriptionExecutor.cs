using LeanCode.Contracts;
using LeanCode.Pipe.Funnel.FunnelledService;
using MassTransit;

namespace LeanCode.Pipe.Funnel.Instance;

public class FunnelSubscriptionExecutor : ISubscriptionExecutor
{
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
        var endpointUri = new Uri(
            endpointNameFormatter.SanitizeName(
                FunnelledSubscriberEndpointNameProvider.GetName(envelope.TopicType)
            )
        );

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
            // TODO: Log error
            return SubscriptionStatus.InternalServerError;
        }
    }
}
