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

        await leanPipeClient.SubscribeSuccessAsync(topic).ConfigureAwait(false);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        var greetingTask = leanPipeClient.WaitForNextNotificationOn<
            SimpleTopic,
            GreetingNotificationDTO
        >(topic);

        var farewellTask = leanPipeClient.WaitForNextNotificationOn<
            SimpleTopic,
            FarewellNotificationDTO
        >(topic);

        await httpClient
            .PostAndEnsureSuccessAsync(
                PublishingExtensions.SimpleTopicPublishEndpoint,
                new NotificationDataDTO
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Greeting,
                    Name = "Tester",
                }
            )
            .ConfigureAwait(false);

        await httpClient
            .PostAndEnsureSuccessAsync(
                PublishingExtensions.SimpleTopicPublishEndpoint,
                new NotificationDataDTO
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Farewell,
                    Name = "Tester",
                }
            )
            .ConfigureAwait(false);

        await Task.WhenAll(greetingTask, farewellTask).ConfigureAwait(false);
        var greeting = await greetingTask.ConfigureAwait(false);
        var farewell = await farewellTask.ConfigureAwait(false);

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

        await leanPipeClient.SubscribeSuccessAsync(topic).ConfigureAwait(false);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        var greetingTask = leanPipeClient.WaitForNextNotificationOn<
            SimpleTopic,
            GreetingNotificationDTO
        >(topic);

        var farewellTask = leanPipeClient.WaitForNextNotificationOn<
            SimpleTopic,
            FarewellNotificationDTO
        >(topic);

        await httpClient
            .PostAndEnsureSuccessAsync(
                PublishingExtensions.SimpleTopicPublishEndpoint,
                new NotificationDataDTO
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Farewell,
                    Name = "Tester",
                }
            )
            .ConfigureAwait(false);

        await httpClient
            .PostAndEnsureSuccessAsync(
                PublishingExtensions.SimpleTopicPublishEndpoint,
                new NotificationDataDTO
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Greeting,
                    Name = "Tester",
                }
            )
            .ConfigureAwait(false);

        await Task.WhenAll(greetingTask, farewellTask).ConfigureAwait(false);
        var greeting = await greetingTask.ConfigureAwait(false);
        var farewell = await farewellTask.ConfigureAwait(false);

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
    public async Task Collecting_future_notifications_for_awaiting_works()
    {
        var topic = new SimpleTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic).ConfigureAwait(false);

        var futureNotifications = leanPipeClient.FutureNotificationsOnAsync(topic);

        await httpClient
            .PostAndEnsureSuccessAsync(
                PublishingExtensions.SimpleTopicPublishEndpoint,
                new NotificationDataDTO
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Greeting,
                    Name = "Tester",
                }
            )
            .ConfigureAwait(false);

        var expectedGreeting = new GreetingNotificationDTO { Greeting = "Hello Tester" };

        (
            await futureNotifications
                .Awaiting(n => n.FirstAsync())
                .Should()
                .CompleteWithinAsync(LeanPipeSubscription.DefaultNotificationAwaitTimeout)
                .ConfigureAwait(false)
        ).Which
            .Should()
            .BeEquivalentTo(expectedGreeting);
    }

    [Fact]
    public async Task Collecting_future_notifications_times_out_if_no_notifications_come()
    {
        var topic = new SimpleTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic).ConfigureAwait(false);

        var timeout = TimeSpan.FromMilliseconds(100);
        var futureNotifications = leanPipeClient.FutureNotificationsOnAsync(topic);

        await httpClient
            .PostAndEnsureSuccessAsync(
                PublishingExtensions.SimpleTopicPublishEndpoint,
                new NotificationDataDTO
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Greeting,
                    Name = "Tester",
                }
            )
            .ConfigureAwait(false);

        await futureNotifications
            .Awaiting(n => n.Take(2).ToListAsync(new CancellationTokenSource(timeout).Token))
            .Should()
            .ThrowAsync<OperationCanceledException>()
            .ConfigureAwait(false);
    }

    [Fact]
    public async Task Collecting_all_notifications_expected_notifications_as_await_method_works()
    {
        var topic = new SimpleTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic).ConfigureAwait(false);

        var greetingTask = leanPipeClient.WaitForNextNotificationOn<
            SimpleTopic,
            GreetingNotificationDTO
        >(topic);

        await httpClient
            .PostAndEnsureSuccessAsync(
                PublishingExtensions.SimpleTopicPublishEndpoint,
                new NotificationDataDTO
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Greeting,
                    Name = "Tester",
                }
            )
            .ConfigureAwait(false);

        await greetingTask.ConfigureAwait(false);

        var allNotifications = leanPipeClient.AllNotificationsOnAsync(topic);

        await httpClient
            .PostAndEnsureSuccessAsync(
                PublishingExtensions.SimpleTopicPublishEndpoint,
                new NotificationDataDTO
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Farewell,
                    Name = "Tester",
                }
            )
            .ConfigureAwait(false);

        var expectedGreeting = new GreetingNotificationDTO { Greeting = "Hello Tester" };
        var expectedFarewell = new FarewellNotificationDTO { Farewell = "Goodbye Tester" };
        var expectedNotifications = new object[] { expectedGreeting, expectedFarewell };

        (
            await allNotifications
                .Awaiting(n => n.Take(2).ToListAsync())
                .Should()
                .CompleteWithinAsync(LeanPipeSubscription.DefaultNotificationAwaitTimeout)
                .ConfigureAwait(false)
        ).Which
            .Should()
            .BeEquivalentTo(expectedNotifications);
    }

    [Fact]
    public async Task Collecting_all_notifications_times_out_if_no_notifications_come()
    {
        var topic = new SimpleTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic).ConfigureAwait(false);

        var timeout = TimeSpan.FromMilliseconds(100);
        var allNotifications = leanPipeClient.AllNotificationsOnAsync(topic);

        await httpClient
            .PostAndEnsureSuccessAsync(
                PublishingExtensions.SimpleTopicPublishEndpoint,
                new NotificationDataDTO
                {
                    TopicId = topic.TopicId,
                    Kind = NotificationKindDTO.Greeting,
                    Name = "Tester",
                }
            )
            .ConfigureAwait(false);

        await allNotifications
            .Awaiting(n => n.Take(2).ToListAsync(new CancellationTokenSource(timeout).Token))
            .Should()
            .ThrowAsync<OperationCanceledException>()
            .ConfigureAwait(false);
    }
}
