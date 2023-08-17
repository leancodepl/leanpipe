using FluentAssertions;
using LeanCode.Components;
using LeanCode.LeanPipe.Extensions;
using LeanCode.LeanPipe.Tests.Additional;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.ObjectPool;
using Xunit;

namespace LeanCode.LeanPipe.Tests;

public class LeanPipeServiceCollectionExtensionsTests
{
    private static readonly TypesCatalog ThisCatalog =
        TypesCatalog.Of<LeanPipeServiceCollectionExtensionsTests>();

    [Fact]
    public void Registers_all_basic_types()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog);
        collection
            .Should()
            .ContainSingle(
                d =>
                    d.ServiceType == typeof(IEnvelopeDeserializer)
                    && d.Lifetime == ServiceLifetime.Singleton
            )
            .And.ContainSingle(
                d =>
                    d.ServiceType == typeof(SubscriptionHandlerResolver)
                    && d.Lifetime == ServiceLifetime.Transient
            )
            .And.ContainSingle(
                d =>
                    d.ServiceType == typeof(LeanPipePublisher<>)
                    && d.Lifetime == ServiceLifetime.Transient
            )
            .And.ContainSingle(
                d =>
                    d.ServiceType == typeof(ISubscriptionHandler<>)
                    && d.Lifetime == ServiceLifetime.Transient
            );
    }

    [Fact]
    public void Updates_deserializer_when_registering_additional_types()
    {
        var collection = new ServiceCollection();
        collection
            .AddLeanPipe(ThisCatalog, ThisCatalog)
            .AddTopics(TypesCatalog.Of<ExternalTopic>());

        var deserializer = collection
            .BuildServiceProvider()
            .GetRequiredService<IEnvelopeDeserializer>();
        var topic = deserializer.Deserialize(Envelope.Empty<ExternalTopic>());

        topic.Should().NotBeNull().And.BeOfType<ExternalTopic>();
    }

    [Fact]
    public void Registers_all_handlers_in_the_assembly()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog);
        var provider = collection.BuildServiceProvider();

        provider
            .GetRequiredService<ISubscriptionHandler<Topic1>>()
            .Should()
            .BeOfType<StubHandler>();
    }

    [Fact]
    public void Does_not_register_handlers_that_cannot_be_instantiated()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog);
        collection.AddTransient<ITopicController<Topic2>, DummyController<Topic2>>();
        var provider = collection.BuildServiceProvider();

        provider
            .GetRequiredService<ISubscriptionHandler<Topic2>>()
            .Should()
            .BeOfType<KeyedSubscriptionHandler<Topic2>>();
    }
}
