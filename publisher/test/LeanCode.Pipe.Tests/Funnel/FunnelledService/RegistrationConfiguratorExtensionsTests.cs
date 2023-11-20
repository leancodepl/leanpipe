using FluentAssertions;
using LeanCode.Components;
using LeanCode.Contracts;
using LeanCode.Pipe.Funnel.FunnelledService;
using LeanCode.Pipe.Tests.Additional;
using MassTransit;
using MassTransit.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Xunit;
using TopicExistenceChecker = LeanCode.Pipe.Funnel.FunnelledService.TopicExistenceChecker;

namespace LeanCode.Pipe.Tests.Funnel.FunnelledService;

public class RegistrationConfiguratorExtensionsTests
{
    private const string ServiceName = "TestService";
    private static readonly TypesCatalog ThisCatalog = TypesCatalog.Of<Topic1>();
    private static readonly TypesCatalog ExternalCatalog = TypesCatalog.Of<ExternalTopic>();

    [Fact]
    public void Registers_consumers_with_default_definition_for_all_correct_specified_topics()
    {
        var collection = new ServiceCollection();
        var configurator = new ServiceCollectionBusConfigurator(collection);
        configurator.AddFunnelledLeanPipeConsumers(
            ServiceName,
            new[] { ThisCatalog, ExternalCatalog }.SelectMany(tc => tc.Assemblies)
        );

        var expectedTypesForConsumers = new[]
        {
            typeof(Topic1),
            typeof(Topic2),
            typeof(ExternalTopic),
        };

        foreach (var type in expectedTypesForConsumers)
        {
            configurator
                .Should()
                .ContainSingle(
                    d => d.ServiceType == typeof(FunnelledSubscriber<>).MakeGenericType(type)
                )
                .And.ContainSingle(
                    d =>
                        d.ServiceType
                        == typeof(FunnelledSubscriberDefinition<>).MakeGenericType(type)
                );
        }
    }

    [Fact]
    public void Skips_registering_consumers_with_default_definition_for_incorrect_specified_topics()
    {
        var collection = new ServiceCollection();
        var configurator = new ServiceCollectionBusConfigurator(collection);
        configurator.AddFunnelledLeanPipeConsumers(
            ServiceName,
            new[] { ThisCatalog, ExternalCatalog }.SelectMany(tc => tc.Assemblies)
        );

        var incorrectTypesForConsumers = new[]
        {
            typeof(AbstractTopic),
            typeof(GenericTopic<int>),
        };

        foreach (var type in incorrectTypesForConsumers)
        {
            configurator
                .Should()
                .NotContain(
                    d => d.ServiceType == typeof(FunnelledSubscriber<>).MakeGenericType(type)
                )
                .And.NotContain(
                    d =>
                        d.ServiceType
                        == typeof(FunnelledSubscriberDefinition<>).MakeGenericType(type)
                );
        }
    }

    [Fact]
    public void Allows_overriding_default_subscriber_consumer_definition()
    {
        var collection = new ServiceCollection();
        var configurator = new ServiceCollectionBusConfigurator(collection);
        configurator.AddFunnelledLeanPipeConsumers(
            ServiceName,
            new[] { ThisCatalog, ExternalCatalog }.SelectMany(tc => tc.Assemblies),
            typeof(FunnelledSubscriberDefinitionOverride<>)
        );
        var provider = collection.BuildServiceProvider();

        provider
            .GetRequiredService<IConsumerDefinition<FunnelledSubscriber<Topic1>>>()
            .Should()
            .BeOfType<FunnelledSubscriberDefinitionOverride<Topic1>>();
    }

    [Fact]
    public void Throws_on_incorrect_override_of_FunnelledSubscriberDefinition()
    {
        var collection = new ServiceCollection();
        var configurator = new ServiceCollectionBusConfigurator(collection);

        ActProvider(typeof(WrongSubscriberDefinition)).Should().Throw<ArgumentException>();
        ActProvider(typeof(AnotherWrongSubscriberDefinition<,>))
            .Should()
            .Throw<ArgumentException>();

        Action ActProvider(Type t) =>
            () =>
                configurator.AddFunnelledLeanPipeConsumers(
                    ServiceName,
                    new[] { ThisCatalog, ExternalCatalog }.SelectMany(tc => tc.Assemblies),
                    t
                );
    }

    [Fact]
    public void Registers_consumer_for_checking_topic_existence()
    {
        var collection = new ServiceCollection();
        var configurator = new ServiceCollectionBusConfigurator(collection);
        configurator.AddFunnelledLeanPipeConsumers(
            ServiceName,
            new[] { ThisCatalog, ExternalCatalog }.SelectMany(tc => tc.Assemblies)
        );

        configurator.Should().ContainSingle(d => d.ServiceType == typeof(TopicExistenceChecker));
    }

    [Fact]
    public void Allows_overriding_checking_topic_existence_consumer_definition()
    {
        var collection = new ServiceCollection();
        var configurator = new ServiceCollectionBusConfigurator(collection);
        configurator.AddFunnelledLeanPipeConsumers(
            ServiceName,
            new[] { ThisCatalog, ExternalCatalog }.SelectMany(tc => tc.Assemblies)
        );
        configurator.AddSingleton<
            IConsumerDefinition<TopicExistenceChecker>,
            TopicExistenceCheckerDefinition
        >();
        var provider = collection.BuildServiceProvider();

        provider
            .GetRequiredService<IConsumerDefinition<TopicExistenceChecker>>()
            .Should()
            .BeOfType<TopicExistenceCheckerDefinition>();
    }

    private sealed class TopicExistenceCheckerDefinition : ConsumerDefinition<TopicExistenceChecker>
    {
        protected override void ConfigureConsumer(
            IReceiveEndpointConfigurator endpointConfigurator,
            IConsumerConfigurator<TopicExistenceChecker> consumerConfigurator,
            IRegistrationContext context
        )
        {
            consumerConfigurator.UseMessageRetry(rc => rc.Immediate(3));
        }
    }

    private sealed class FunnelledSubscriberDefinitionOverride<TTopic>
        : FunnelledSubscriberDefinition<TTopic>
        where TTopic : ITopic
    {
        protected override void ConfigureConsumer(
            IReceiveEndpointConfigurator endpointConfigurator,
            IConsumerConfigurator<FunnelledSubscriber<TTopic>> consumerConfigurator,
            IRegistrationContext context
        )
        {
            consumerConfigurator.UseMessageRetry(rc => rc.Immediate(3));
        }
    }

    private sealed class WrongSubscriberDefinition { }

    private sealed class AnotherWrongSubscriberDefinition<T1, T2> { }
}
