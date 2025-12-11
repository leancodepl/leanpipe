using MassTransit;
using MassTransit.SignalR;
using MassTransit.SignalR.Configuration.Definitions;
using MassTransit.SignalR.Consumers;
using MassTransit.SignalR.Scoping;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanCode.Pipe.Funnel.Instance;

public static class RegistrationConfiguratorExtensions
{
    /// <summary>
    /// Adds special MassTransit SignalR hub lifetime manager and configures required consumer.
    /// </summary>
    /// <param name="configurator">MassTransit bus registration configurator.</param>
    /// <param name="configureHubLifetimeOptions">Configures hub lifetime.</param>
    public static void ConfigureLeanPipeFunnelConsumers(
        this IRegistrationConfigurator configurator,
        Action<IHubLifetimeManagerOptions<LeanPipeSubscriber>>? configureHubLifetimeOptions = null
    )
    {
        var options = new HubLifetimeManagerOptions<LeanPipeSubscriber>();
        configureHubLifetimeOptions?.Invoke(options);

        configurator.TryAddSingleton<
            IHubLifetimeScopeProvider,
            DependencyInjectionHubLifetimeScopeProvider
        >();

        configurator.AddSingleton(provider => GetMassTransitHubLifetimeManager(provider, options));
        configurator.AddSingleton<HubLifetimeManager<LeanPipeSubscriber>>(sp =>
            sp.GetRequiredService<MassTransitHubLifetimeManager<LeanPipeSubscriber>>()
        );

        configurator.AddSingleton<HubConsumerDefinition<LeanPipeSubscriber>>();

        configurator.TryAddSingleton<
            IConsumerDefinition<GroupConsumer<LeanPipeSubscriber>>,
            GroupConsumerDefinition<LeanPipeSubscriber>
        >();
        configurator.AddConsumer<GroupConsumer<LeanPipeSubscriber>>();
    }

    private static MassTransitHubLifetimeManager<LeanPipeSubscriber> GetMassTransitHubLifetimeManager(
        IServiceProvider provider,
        HubLifetimeManagerOptions<LeanPipeSubscriber> options
    )
    {
        var scopeProvider = provider.GetRequiredService<IHubLifetimeScopeProvider>();
        var resolver = provider.GetRequiredService<IHubProtocolResolver>();
        return new(options, scopeProvider, resolver);
    }
}
