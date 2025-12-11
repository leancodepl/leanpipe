using FluentAssertions;
using LeanCode.Pipe.Funnel.Instance;
using MassTransit.Configuration;
using MassTransit.SignalR.Consumers;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

namespace LeanCode.Pipe.Funnel.Tests.Instance;

public class RegistrationConfiguratorExtensionsTests
{
    [Fact]
    public void Registers_required_types_for_the_funnel()
    {
        var collection = new ServiceCollection();
        var configurator = new ServiceCollectionBusConfigurator(collection);
        configurator.ConfigureLeanPipeFunnelConsumers();

        configurator
            .Should()
            .ContainSingle(d => d.ServiceType == typeof(HubLifetimeManager<LeanPipeSubscriber>))
            .And.ContainSingle(d => d.ServiceType == typeof(GroupConsumer<LeanPipeSubscriber>));
    }
}
