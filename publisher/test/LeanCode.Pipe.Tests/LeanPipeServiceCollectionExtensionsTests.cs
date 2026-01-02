using System.Text.Json;
using LeanCode.Components;
using LeanCode.Pipe.Tests.Additional;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Options;

namespace LeanCode.Pipe.Tests;

public class LeanPipeServiceCollectionExtensionsTests
{
    private static readonly TypesCatalog ThisCatalog = TypesCatalog.Of<Topic1>();
    private static readonly TypesCatalog ExternalCatalog = TypesCatalog.Of<ExternalTopic>();

    [Fact]
    public void Registers_all_basic_types()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog);
        collection
            .Should()
            .ContainSingle(d =>
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
                d.ServiceType == typeof(ISubscriptionExecutor)
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
    public void Updates_deserializer_when_registering_additional_types()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog).AddTopics(ExternalCatalog);

        var deserializer = collection.BuildServiceProvider().GetRequiredService<ITopicExtractor>();
        var topic = deserializer.Extract(Envelope.Empty<ExternalTopic>());

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
        collection.AddTransient<ISubscribingKeys<Topic2>, DummyKeys<Topic2>>();
        var provider = collection.BuildServiceProvider();

        provider
            .GetRequiredService<ISubscriptionHandler<Topic2>>()
            .Should()
            .BeOfType<KeyedSubscriptionHandler<Topic2>>();
    }

    [Fact]
    public void Registers_topic_keys_if_provided()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog);
        var provider = collection.BuildServiceProvider();

        provider
            .GetRequiredService<ISubscribingKeys<TopicWithAllKeys>>()
            .Should()
            .BeOfType<TopicWithAllKeysKeys>();
    }

    [Fact]
    public void Registers_KeyedSubscriptionHandler_by_default()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog);
        var provider = collection.BuildServiceProvider();

        provider
            .GetRequiredService<ISubscriptionHandler<TopicWithAllKeys>>()
            .Should()
            .BeOfType<KeyedSubscriptionHandler<TopicWithAllKeys>>();
    }

    [Fact]
    public void Registers_all_notification_keys()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog);
        var provider = collection.BuildServiceProvider();

        provider
            .GetRequiredService<IPublishingKeys<TopicWithAllKeys, Notification1>>()
            .Should()
            .BeOfType<TopicWithAllKeysKeys>();
        provider
            .GetRequiredService<IPublishingKeys<TopicWithAllKeys, Notification2>>()
            .Should()
            .BeOfType<TopicWithAllKeysKeys>();
    }

    [Fact]
    public void Throws_if_user_does_not_provide_all_notification_keys_implementation_but_provides_at_least_one()
    {
        var collection = new ServiceCollection();
        var builder = collection.AddLeanPipe(ThisCatalog, ThisCatalog);

        var act = () => builder.AddHandlers(ExternalCatalog);
        act.Should().Throw<InvalidOperationException>();
    }

    [Fact]
    public void Default_serializer_configuration_is_applied_when_no_override_is_provided()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog);

        var provider = collection.BuildServiceProvider();
        var hubProtocolOptions = provider
            .GetRequiredService<IOptions<JsonHubProtocolOptions>>()
            .Value;

        hubProtocolOptions.PayloadSerializerOptions.PropertyNamingPolicy.Should().BeNull();
    }

    [Fact]
    public void Override_replaces_default_serializer_configuration()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(
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

    [Fact]
    public void Hub_options_delegate_is_invoked_when_provided()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(
            ThisCatalog,
            ThisCatalog,
            configureLeanPipeHub: options => options.MaximumReceiveMessageSize = 12345
        );

        var provider = collection.BuildServiceProvider();
        var hubOptions = provider
            .GetRequiredService<IOptions<HubOptions<LeanPipeSubscriber>>>()
            .Value;

        hubOptions.MaximumReceiveMessageSize.Should().Be(12345);
    }
}
