using LeanCode.Contracts;
using MassTransit;

namespace LeanCode.Pipe.Funnel.FunnelledService;

public record ExecuteTopicsSubscriptionPipeline(
    SubscriptionEnvelope Envelope,
    OperationType OperationType,
    LeanPipeContext Context
);

public record SubscriptionPipelineResult(SubscriptionStatus Status, List<string> GroupKeys);

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

        var groupKeys = subscribeContext.GroupKeys!;

        await context.RespondAsync<SubscriptionPipelineResult>(
            new(subscriptionStatus, groupKeys.ToList())
        );
    }
}

public class FunnelledSubscriberDefinition<TTopic> : ConsumerDefinition<FunnelledSubscriber<TTopic>>
    where TTopic : ITopic
{
    protected override void ConfigureConsumer(
        IReceiveEndpointConfigurator endpointConfigurator,
        IConsumerConfigurator<FunnelledSubscriber<TTopic>> consumerConfigurator,
        IRegistrationContext context
    )
    {
        Endpoint(cfg =>
        {
            cfg.Name = FunnelledSubscriberEndpointNameProvider.GetName<TTopic>();
        });
    }
}
