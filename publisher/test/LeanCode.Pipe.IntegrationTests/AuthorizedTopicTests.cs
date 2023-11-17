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
        var leanPipeClient = CreateLeanPipeTestClient(AuthenticatedAs.NotAuthenticated);
        var topic = new AuthorizedTopic { TopicId = Guid.NewGuid() };

        var result = await leanPipeClient.SubscribeAsync(topic);
        result.Should().BeEquivalentTo(new { Status = SubscriptionStatus.Unauthorized });

        await httpClient.PublishToAuthorizedTopicAndAwaitNoNotificationsAsync(
            new()
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            }
        );

        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();
    }

    [Fact]
    public async Task User_with_insufficient_role_subscribing_to_authorized_topic_gets_unauthorized_response_and_receives_no_notifications()
    {
        var leanPipeClient = CreateLeanPipeTestClient(AuthenticatedAs.UserWithoutRole);
        var topic = new AuthorizedTopic { TopicId = Guid.NewGuid() };

        var result = await leanPipeClient.SubscribeAsync(topic);
        result.Should().BeEquivalentTo(new { Status = SubscriptionStatus.Unauthorized });

        await httpClient
            .PublishToAuthorizedTopicAndAwaitNoNotificationsAsync(
                new()
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Greeting,
                    Name = "Tester",
                }
            )
            ;

        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();
    }

    [Fact]
    public async Task User_with_sufficient_role_subscribes_to_authorized_topic_and_receives_notifications()
    {
        var leanPipeClient = CreateLeanPipeTestClient(AuthenticatedAs.User);
        var topic = new AuthorizedTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);

        await httpClient
            .PublishToAuthorizedTopicAndAwaitNotificationAsync(
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
    }
}
