using LeanCode.Contracts;
using MassTransit;

namespace LeanCode.Pipe.Funnel.FunnelledService;

public class FunnelledSubscriber<TTopic> : IConsumer<ExecuteTopicsSubscriptionPipeline>
    where TTopic : ITopic
{
    private readonly SubscriptionExecutor subscriptionExecutor;

    public FunnelledSubscriber(SubscriptionExecutor subscriptionExecutor)
    {
        this.subscriptionExecutor = subscriptionExecutor;
    }

    public async Task Consume(ConsumeContext<ExecuteTopicsSubscriptionPipeline> context)
    {
        var msg = context.Message;

        var subscribeContext = new FunnelledSubscribeContext();

        var subscriptionStatus = await subscriptionExecutor.ExecuteAsync(
            msg.Envelope,
            msg.OperationType,
            subscribeContext,
            msg.Context,
            context.CancellationToken
        );

        await context.RespondAsync<SubscriptionPipelineResult>(
            new(subscriptionStatus, subscribeContext.GroupKeys?.ToList() ?? new())
        );
    }
}

public class FunnelledSubscriberDefinition<TTopic> : ConsumerDefinition<FunnelledSubscriber<TTopic>>
    where TTopic : ITopic
{
    public FunnelledSubscriberDefinition()
    {
        EndpointName = FunnelledSubscriberEndpointNameProvider.GetName<TTopic>();
    }
}
