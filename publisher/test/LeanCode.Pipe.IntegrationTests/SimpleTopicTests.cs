using FluentAssertions;
using LeanCode.Pipe.IntegrationTests.App;
using LeanCode.Pipe.TestClient;
using Xunit;

namespace LeanCode.Pipe.IntegrationTests;

public class SimpleTopicTests : TestApplicationFactory
{
    private readonly HttpClient httpClient;
    private readonly LeanPipeTestClient leanPipeClient;

    public SimpleTopicTests()
    {
        httpClient = CreateClient();
        leanPipeClient = CreateLeanPipeTestClient(AuthenticatedAs.NotAuthenticated);
    }

    [Fact]
    public async Task Subscriber_receives_both_kinds_of_notifications_when_subscribed()
    {
        var topic = new SimpleTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        await httpClient.PublishToSimpleTopicAndAwaitNotificationAsync(
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

        await httpClient.PublishToSimpleTopicAndAwaitNotificationAsync(
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

        await httpClient.PublishToSimpleTopicAndAwaitNoNotificationsAsync(
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
        var topic = new SimpleTopic { TopicId = Guid.NewGuid() };
        var otherTopic = new SimpleTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);

        await httpClient
            .PublishToSimpleTopicAndAwaitNoNotificationsAsync(
                new()
                {
                    TopicId = otherTopic.TopicId,
                    Kind = NotificationKindDTO.Greeting,
                    Name = "Tester",
                }
            )
            ;

        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();
        leanPipeClient.NotificationsOn(otherTopic).Should().BeEmpty();

        await leanPipeClient.UnsubscribeSuccessAsync(topic);
    }

    [Fact]
    public async Task Resubscribing_after_disconnect_works()
    {
        var topic = new SimpleTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        await httpClient
            .PublishToSimpleTopicAndAwaitNotificationAsync(
                new()
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Greeting,
                    Name = "Tester",
                },
                leanPipeClient,
                topic,
                new GreetingNotificationDTO { Greeting = "Hello Tester" }
            )
            ;

        await leanPipeClient.DisconnectAsync();
        await leanPipeClient.SubscribeSuccessAsync(topic);

        await httpClient
            .PublishToSimpleTopicAndAwaitNotificationAsync(
                new()
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Farewell,
                    Name = "Tester",
                },
                leanPipeClient,
                topic,
                new FarewellNotificationDTO { Farewell = "Goodbye Tester" }
            )
            ;

        await leanPipeClient.UnsubscribeSuccessAsync(topic);
    }
}
