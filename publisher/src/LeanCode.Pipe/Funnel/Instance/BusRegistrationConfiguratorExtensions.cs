using MassTransit;
using MassTransit.SignalR;
using MassTransit.SignalR.Configuration.Definitions;
using MassTransit.SignalR.Consumers;
using MassTransit.SignalR.Scoping;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanCode.Pipe.Funnel.Instance;

public static class BusRegistrationConfiguratorExtensions
{
    public static void ConfigureLeanPipeFunnelConsumers(
        this IBusRegistrationConfigurator busConfigurator,
        Action<IHubLifetimeManagerOptions<LeanPipeSubscriber>>? configureHubLifetimeOptions = null
    )
    {
        var options = new HubLifetimeManagerOptions<LeanPipeSubscriber>();
        configureHubLifetimeOptions?.Invoke(options);

        busConfigurator.TryAddSingleton<
            IHubLifetimeScopeProvider,
            DependencyInjectionHubLifetimeScopeProvider
        >();

        busConfigurator.AddSingleton(
            provider => GetMassTransitHubLifetimeManager(provider, options)
        );
        busConfigurator.AddSingleton<HubLifetimeManager<LeanPipeSubscriber>>(
            sp => sp.GetRequiredService<MassTransitHubLifetimeManager<LeanPipeSubscriber>>()
        );

        busConfigurator.AddSingleton<HubConsumerDefinition<LeanPipeSubscriber>>();

        busConfigurator.TryAddSingleton<
            IConsumerDefinition<GroupConsumer<LeanPipeSubscriber>>,
            GroupConsumerDefinition<LeanPipeSubscriber>
        >();
        busConfigurator.AddConsumer<GroupConsumer<LeanPipeSubscriber>>();
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
