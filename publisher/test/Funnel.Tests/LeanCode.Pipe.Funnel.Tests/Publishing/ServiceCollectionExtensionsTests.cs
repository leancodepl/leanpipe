using System.Text.Json;
using LeanCode.Components;
using LeanCode.Pipe.Funnel.Publishing;
using LeanCode.Pipe.Tests;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace LeanCode.Pipe.Funnel.Tests.Publishing;

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
    public void Default_serializer_configuration_is_applied_to_funnelled_when_no_override_is_provided()
    {
        var collection = new ServiceCollection();
        collection.AddFunnelledLeanPipe(ThisCatalog, ThisCatalog);

        var provider = collection.BuildServiceProvider();
        var hubProtocolOptions = provider
            .GetRequiredService<IOptions<JsonHubProtocolOptions>>()
            .Value;

        hubProtocolOptions.PayloadSerializerOptions.PropertyNamingPolicy.Should().BeNull();
    }

    [Fact]
    public void Override_replaces_default_serializer_configuration_in_funnelled()
    {
        var collection = new ServiceCollection();
        collection.AddFunnelledLeanPipe(
            ThisCatalog,
            ThisCatalog,
            overrideJsonHubProtocolOptions: options =>
                options.PayloadSerializerOptions.PropertyNamingPolicy = JsonNamingPolicy.CamelCase
        );

        var provider = collection.BuildServiceProvider();
        var hubProtocolOptions = provider
            .GetRequiredService<IOptions<JsonHubProtocolOptions>>()
            .Value;

        hubProtocolOptions
            .PayloadSerializerOptions.PropertyNamingPolicy.Should()
            .Be(JsonNamingPolicy.CamelCase);
    }
}
