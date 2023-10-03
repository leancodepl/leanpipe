using FluentAssertions;
using LeanCode.Pipe.IntegrationTests.App;
using LeanCode.Pipe.TestClient;
using Xunit;

namespace LeanCode.Pipe.IntegrationTests;

public class TestClientTests : TestApplicationFactory
{
    private readonly HttpClient httpClient;
    private readonly LeanPipeTestClient leanPipeClient;

    public TestClientTests()
    {
        httpClient = CreateClient();
        leanPipeClient = CreateLeanPipeTestClient(AuthenticatedAs.NotAuthenticated);
    }

    [Fact]
    public async Task Awaiting_multiple_notifications_with_different_predicates_works()
    {
        var topic = new SimpleTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        var greetingTask = leanPipeClient.WaitForNextNotificationOn<
            SimpleTopic,
            GreetingNotificationDTO
        >(topic);

        var farewellTask = leanPipeClient.WaitForNextNotificationOn<
            SimpleTopic,
            FarewellNotificationDTO
        >(topic);

        await httpClient.PostAndEnsureSuccessAsync(
            PublishingExtensions.SimpleTopicPublishEndpoint,
            new NotificationDataDTO
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            }
        );

        await httpClient.PostAndEnsureSuccessAsync(
            PublishingExtensions.SimpleTopicPublishEndpoint,
            new NotificationDataDTO
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Farewell,
                Name = "Tester",
            }
        );

        await Task.WhenAll(greetingTask, farewellTask);
        var greeting = await greetingTask;
        var farewell = await farewellTask;

        var expectedGreeting = new GreetingNotificationDTO { Greeting = "Hello Tester" };
        var expectedFarewell = new FarewellNotificationDTO { Farewell = "Goodbye Tester" };

        greeting.Should().BeEquivalentTo(expectedGreeting);
        farewell.Should().BeEquivalentTo(expectedFarewell);

        leanPipeClient
            .NotificationsOn(topic)
            .Should()
            .BeEquivalentTo(new object[] { greeting, farewell });
    }

    [Fact]
    public async Task Awaiting_multiple_notifications_with_different_predicates_works_with_different_publish_order()
    {
        var topic = new SimpleTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        var greetingTask = leanPipeClient.WaitForNextNotificationOn<
            SimpleTopic,
            GreetingNotificationDTO
        >(topic);

        var farewellTask = leanPipeClient.WaitForNextNotificationOn<
            SimpleTopic,
            FarewellNotificationDTO
        >(topic);

        await httpClient.PostAndEnsureSuccessAsync(
            PublishingExtensions.SimpleTopicPublishEndpoint,
            new NotificationDataDTO
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Farewell,
                Name = "Tester",
            }
        );

        await httpClient.PostAndEnsureSuccessAsync(
            PublishingExtensions.SimpleTopicPublishEndpoint,
            new NotificationDataDTO
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            }
        );

        await Task.WhenAll(greetingTask, farewellTask);
        var greeting = await greetingTask;
        var farewell = await farewellTask;

        var expectedGreeting = new GreetingNotificationDTO { Greeting = "Hello Tester" };
        var expectedFarewell = new FarewellNotificationDTO { Farewell = "Goodbye Tester" };

        greeting.Should().BeEquivalentTo(expectedGreeting);
        farewell.Should().BeEquivalentTo(expectedFarewell);

        leanPipeClient
            .NotificationsOn(topic)
            .Should()
            .BeEquivalentTo(new object[] { greeting, farewell });
    }
}
