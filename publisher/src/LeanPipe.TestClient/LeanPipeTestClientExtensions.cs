using FluentAssertions;
using LeanCode.Contracts;

namespace LeanPipe.TestClient;

public static class LeanPipeTestClientExtensions
{
    public static async Task<Guid> SubscribeSuccessAsync<TTopic>(
        this LeanPipeTestClient client,
        TTopic topic,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        var subscriptionResult = await client.SubscribeAsync(topic, ct);

        subscriptionResult
            .Should()
            .BeEquivalentTo(
                new SubscriptionResult(
                    Guid.Empty,
                    SubscriptionStatus.Success,
                    OperationType.Subscribe
                ),
                opts => opts.Excluding(e => e.SubscriptionId)
            );

        return subscriptionResult!.SubscriptionId;
    }

    public static async Task<Guid> UnsubscribeSuccessAsync<TTopic>(
        this LeanPipeTestClient client,
        TTopic topic,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        var subscriptionResult = await client.UnsubscribeAsync(topic, ct);

        subscriptionResult
            .Should()
            .BeEquivalentTo(
                new SubscriptionResult(
                    Guid.Empty,
                    SubscriptionStatus.Success,
                    OperationType.Unsubscribe
                ),
                opts => opts.Excluding(e => e.SubscriptionId)
            );

        return subscriptionResult!.SubscriptionId;
    }

    public static void CheckLastNotificationsOnTopic<TTopic, TNotification>(
        this LeanPipeTestClient client,
        TTopic topic,
        params TNotification[] notifications
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        client.ReceivedNotifications
            .Should()
            .ContainKey(topic)
            .WhoseValue.Should()
            .HaveCountGreaterOrEqualTo(notifications.Length)
            .And.Subject.TakeLast(notifications.Length)
            .Should()
            .BeEquivalentTo(
                notifications,
                opts => opts.WithStrictOrdering().RespectingRuntimeTypes()
            );
    }
}
