using LeanCode.Components;
using LeanCode.Pipe.Funnel.Instance;
using LeanCode.Pipe.Funnel.Publishing;
using LeanCode.Pipe.Tests;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.Funnel.Tests;

public class ServiceCollectionExtensionsTests
{
    private static readonly TypesCatalog ThisCatalog = TypesCatalog.Of<Topic1>();

    [Fact]
    public void Registers_required_basic_types_when_service_is_funnelled()
    {
        var collection = new ServiceCollection();
        collection.AddFunnelledLeanPipe(ThisCatalog, ThisCatalog);
        collection
            .Should()
            .NotContain(d =>
                d.ServiceType == typeof(HubLifetimeManager<>)
                && d.Lifetime == ServiceLifetime.Singleton
            )
            .And.ContainSingle(d =>
                d.ServiceType == typeof(ITopicExtractor) && d.Lifetime == ServiceLifetime.Singleton
            )
            .And.ContainSingle(d =>
                d.ServiceType == typeof(LeanPipeSecurity) && d.Lifetime == ServiceLifetime.Transient
            )
            .And.ContainSingle(d =>
                d.ServiceType == typeof(SubscriptionExecutor)
                && d.Lifetime == ServiceLifetime.Transient
            )
            .And.ContainSingle(d =>
                d.ServiceType == typeof(SubscriptionHandlerResolver)
                && d.Lifetime == ServiceLifetime.Transient
            )
            .And.ContainSingle(d =>
                d.ServiceType == typeof(ILeanPipePublisher<>)
                && d.Lifetime == ServiceLifetime.Transient
            )
            .And.ContainSingle(d =>
                d.ServiceType == typeof(ISubscriptionHandler<>)
                && d.Lifetime == ServiceLifetime.Transient
            );
    }

    [Fact]
    public void Registers_required_basic_types_when_service_is_funnel()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipeFunnel();
        collection
            .Should()
            .ContainSingle(d =>
                d.ServiceType == typeof(HubLifetimeManager<>)
                && d.Lifetime == ServiceLifetime.Singleton
            )
            .And.ContainSingle(d =>
                d.ServiceType == typeof(IMemoryCache) && d.Lifetime == ServiceLifetime.Singleton
            )
            .And.ContainSingle(d =>
                d.ServiceType == typeof(FunnelConfiguration)
                && d.Lifetime == ServiceLifetime.Singleton
            )
            .And.ContainSingle(d =>
                d.ServiceType == typeof(ISubscriptionExecutor)
                && d.Lifetime == ServiceLifetime.Transient
            );
    }
}
