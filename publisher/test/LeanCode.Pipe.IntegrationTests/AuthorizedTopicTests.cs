using FluentAssertions;
using LeanCode.Contracts;
using LeanCode.Pipe.IntegrationTests.App;
using LeanCode.Pipe.TestClient;
using Xunit;

namespace LeanCode.Pipe.IntegrationTests;

public class AuthorizedTopicTests : TestApplicationFactory
{
    private readonly HttpClient httpClient;

    public AuthorizedTopicTests()
    {
        httpClient = CreateClient();
    }

    [Fact]
    public async Task Unauthenticated_user_subscribing_to_authorized_topic_gets_unauthorized_response_and_receives_no_notifications()
    {
        var pipeClient = CreatePipeTestClient(AuthenticatedAs.NotAuthenticated);
        var topic = new AuthorizedTopic { TopicId = Guid.NewGuid() };

        var result = await pipeClient.SubscribeAsync(topic);
        result.Should().BeEquivalentTo(new { Status = SubscriptionStatus.Unauthorized });

        await httpClient.PublishToAuthorizedTopicAndAwaitNoNotificationsAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            }
        );

        pipeClient.NotificationsOn(topic).Should().BeEmpty();
    }

    [Fact]
    public async Task User_with_insufficient_role_subscribing_to_authorized_topic_gets_unauthorized_response_and_receives_no_notifications()
    {
        var pipeClient = CreatePipeTestClient(AuthenticatedAs.UserWithoutRole);
        var topic = new AuthorizedTopic { TopicId = Guid.NewGuid() };

        var result = await pipeClient.SubscribeAsync(topic);
        result.Should().BeEquivalentTo(new { Status = SubscriptionStatus.Unauthorized });

        await httpClient.PublishToAuthorizedTopicAndAwaitNoNotificationsAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            }
        );

        pipeClient.NotificationsOn(topic).Should().BeEmpty();
    }

    [Fact]
    public async Task User_with_sufficient_role_subscribes_to_authorized_topic_and_receives_notifications()
    {
        var pipeClient = CreatePipeTestClient(AuthenticatedAs.User);
        var topic = new AuthorizedTopic { TopicId = Guid.NewGuid() };

        await pipeClient.SubscribeSuccessAsync(topic);

        await httpClient.PublishToAuthorizedTopicAndAwaitNotificationAsync(
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
    }
}
