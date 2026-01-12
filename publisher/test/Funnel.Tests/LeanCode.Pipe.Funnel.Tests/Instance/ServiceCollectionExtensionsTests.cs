using System.Text.Json;
using LeanCode.Pipe.Funnel.Instance;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace LeanCode.Pipe.Funnel.Tests.Instance;

public class ServiceCollectionExtensionsTests
{
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

    [Fact]
    public void Default_serializer_configuration_is_applied_to_funnel_when_no_override_is_provided()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipeFunnel();

        var provider = collection.BuildServiceProvider();
        var hubProtocolOptions = provider
            .GetRequiredService<IOptions<JsonHubProtocolOptions>>()
            .Value;

        hubProtocolOptions.PayloadSerializerOptions.PropertyNamingPolicy.Should().BeNull();
    }

    [Fact]
    public void Override_replaces_default_serializer_configuration_in_funnel()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipeFunnel(overrideJsonHubProtocolOptions: options =>
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

    [Fact]
    public void Hub_options_delegate_is_invoked_when_provided_to_funnel()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipeFunnel(configureLeanPipeHub: options =>
            options.MaximumReceiveMessageSize = 12345
        );

        var provider = collection.BuildServiceProvider();
        var hubOptions = provider
            .GetRequiredService<IOptions<HubOptions<LeanPipeSubscriber>>>()
            .Value;

        hubOptions.MaximumReceiveMessageSize.Should().Be(12345);
    }
}
