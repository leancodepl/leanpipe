using FluentAssertions;
using LeanCode.Contracts;
using Xunit;

namespace LeanCode.Pipe.TestClient.Tests;

public class LeanPipeSubscriptionTests
{
    [Fact]
    public async Task Waiting_for_next_notification_completes_task_with_the_notification_when_it_arrives()
    {
        var subscription = new LeanPipeSubscription(new Topic(), Guid.NewGuid());

        var notificationTask = subscription.WaitForNextNotification();

        var notification = new Notification { Message = "Hello!" };

        subscription.AddNotification(notification);

        (
            await notificationTask.Awaiting(t => t).Should().NotThrowAsync().ConfigureAwait(false)
        ).Which
            .Should()
            .Be(notification);
    }

    [Fact]
    public async Task Waiting_for_next_notification_cancels_when_passed_token_is_canceled()
    {
        var subscription = new LeanPipeSubscription(new Topic(), Guid.NewGuid());

        var timeout = TimeSpan.FromMilliseconds(100);

        var notificationTask = subscription.WaitForNextNotification(timeout: timeout);

        // `ThrowWithinAsync<OperationCanceledException>(timeout.Add(timeout))` seems to fail though 🤨
        await notificationTask
            .Awaiting(t => t)
            .Should()
            .ThrowAsync<OperationCanceledException>()
            .ConfigureAwait(false);
    }

    private class Topic : ITopic, IProduceNotification<Notification> { }

    private class Notification
    {
        public string Message { get; set; } = default!;
    }
}
