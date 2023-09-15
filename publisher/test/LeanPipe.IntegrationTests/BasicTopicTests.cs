using FluentAssertions;
using LeanPipe.IntegrationTests.App;
using LeanPipe.TestClient;
using Xunit;

namespace LeanPipe.IntegrationTests;

public class BasicTopicTests : TestApplicationFactory
{
    private readonly HttpClient httpClient;
    private readonly LeanPipeTestClient leanPipeClient;

    public BasicTopicTests()
    {
        httpClient = CreateClient();
        leanPipeClient = new(
            new("http://localhost/leanpipe"),
            Program.LeanPipeTypes,
            hco =>
            {
                hco.HttpMessageHandlerFactory = _ => Server.CreateHandler();
            }
        );
    }

    [Fact]
    public async Task Subscriber_receives_both_kinds_of_notifications_when_subscribed()
    {
        var topic = new BasicTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        await httpClient.PublishToBasicTopicAndAwaitNotificationAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            },
            leanPipeClient,
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
            leanPipeClient,
            topic,
            new FarewellNotificationDTO { Farewell = "Goodbye Tester" }
        );

        await leanPipeClient.UnsubscribeSuccessAsync(topic);

        await httpClient.PublishToBasicTopicAndAwaitNoNotificationsAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Farewell,
                Name = "other Tester",
            }
        );

        leanPipeClient.NotificationsOn(topic).Should().HaveCount(2);
    }

    [Fact]
    public async Task Subscriber_does_not_receive_messages_from_other_topic_instances()
    {
        var topic = new BasicTopic { TopicId = Guid.NewGuid() };
        var otherTopic = new BasicTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);

        await httpClient.PublishToBasicTopicAndAwaitNoNotificationsAsync(
            new()
            {
                TopicId = otherTopic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            }
        );

        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();
        leanPipeClient.NotificationsOn(otherTopic).Should().BeEmpty();

        await leanPipeClient.UnsubscribeSuccessAsync(topic);
    }

    [Fact]
    public async Task Resubscribing_after_disconnect_works()
    {
        var topic = new BasicTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        await httpClient.PublishToBasicTopicAndAwaitNotificationAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            },
            leanPipeClient,
            topic,
            new GreetingNotificationDTO { Greeting = "Hello Tester" }
        );

        await leanPipeClient.DisconnectAsync();
        await leanPipeClient.SubscribeSuccessAsync(topic);

        await httpClient.PublishToBasicTopicAndAwaitNotificationAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Farewell,
                Name = "Tester",
            },
            leanPipeClient,
            topic,
            new FarewellNotificationDTO { Farewell = "Goodbye Tester" }
        );

        await leanPipeClient.UnsubscribeSuccessAsync(topic);
    }
}
