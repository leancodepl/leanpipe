using FluentAssertions;
using LeanCode.Pipe.IntegrationTests.App;
using LeanCode.Pipe.TestClient;
using Xunit;

namespace LeanCode.Pipe.IntegrationTests;

public class BasicTopicTests : TestApplicationFactory
{
    private readonly HttpClient httpClient;
    private readonly PipeTestClient pipeClient;

    public BasicTopicTests()
    {
        httpClient = CreateClient();
        pipeClient = CreatePipeTestClient(AuthenticatedAs.NotAuthenticated);
    }

    [Fact]
    public async Task Subscriber_receives_both_kinds_of_notifications_when_subscribed()
    {
        var topic = new BasicTopic { TopicId = Guid.NewGuid() };

        await pipeClient.SubscribeSuccessAsync(topic);
        pipeClient.NotificationsOn(topic).Should().BeEmpty();

        await httpClient.PublishToBasicTopicAndAwaitNotificationAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            },
            pipeClient,
            topic,
            new GreetingNotificationDTO { Greeting = "Hello Tester" }
        );

        await httpClient.PublishToBasicTopicAndAwaitNotificationAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Farewell,
                Name = "Tester",
            },
            pipeClient,
            topic,
            new FarewellNotificationDTO { Farewell = "Goodbye Tester" }
        );

        await pipeClient.UnsubscribeSuccessAsync(topic);

        await httpClient.PublishToBasicTopicAndAwaitNoNotificationsAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Farewell,
                Name = "other Tester",
            }
        );

        pipeClient.NotificationsOn(topic).Should().HaveCount(2);
    }

    [Fact]
    public async Task Subscriber_does_not_receive_messages_from_other_topic_instances()
    {
        var topic = new BasicTopic { TopicId = Guid.NewGuid() };
        var otherTopic = new BasicTopic { TopicId = Guid.NewGuid() };

        await pipeClient.SubscribeSuccessAsync(topic);

        await httpClient.PublishToBasicTopicAndAwaitNoNotificationsAsync(
            new()
            {
                TopicId = otherTopic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            }
        );

        pipeClient.NotificationsOn(topic).Should().BeEmpty();
        pipeClient.NotificationsOn(otherTopic).Should().BeEmpty();

        await pipeClient.UnsubscribeSuccessAsync(topic);
    }

    [Fact]
    public async Task Resubscribing_after_disconnect_works()
    {
        var topic = new BasicTopic { TopicId = Guid.NewGuid() };

        await pipeClient.SubscribeSuccessAsync(topic);
        pipeClient.NotificationsOn(topic).Should().BeEmpty();

        await httpClient.PublishToBasicTopicAndAwaitNotificationAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            },
            pipeClient,
            topic,
            new GreetingNotificationDTO { Greeting = "Hello Tester" }
        );

        await pipeClient.DisconnectAsync();
        await pipeClient.SubscribeSuccessAsync(topic);

        await httpClient.PublishToBasicTopicAndAwaitNotificationAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Farewell,
                Name = "Tester",
            },
            pipeClient,
            topic,
            new FarewellNotificationDTO { Farewell = "Goodbye Tester" }
        );

        await pipeClient.UnsubscribeSuccessAsync(topic);
    }
}
