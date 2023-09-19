using LeanCode.Contracts;

namespace LeanCode.Pipe.TestClient;

public static class PipeTestClientExtensions
{
    private static readonly TimeSpan DefaultNotificationAwaitTimeout = TimeSpan.FromSeconds(10);

    public static async Task<Guid> SubscribeSuccessAsync<TTopic>(
        this PipeTestClient client,
        TTopic topic,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        var subscriptionResult = await client.SubscribeAsync(topic, ct);

        if (
            subscriptionResult?.Type == OperationType.Subscribe
            && subscriptionResult.Status == SubscriptionStatus.Success
        )
        {
            return subscriptionResult.SubscriptionId;
        }
        else
        {
            throw new InvalidOperationException(
                "Pipe test client did not manage to subscribe to topic with success."
            );
        }
    }

    public static async Task<Guid> UnsubscribeSuccessAsync<TTopic>(
        this PipeTestClient client,
        TTopic topic,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        var subscriptionResult = await client.UnsubscribeAsync(topic, ct);

        if (
            subscriptionResult?.Type == OperationType.Unsubscribe
            && subscriptionResult.Status == SubscriptionStatus.Success
        )
        {
            return subscriptionResult.SubscriptionId;
        }
        else
        {
            throw new InvalidOperationException(
                "Pipe test client did not manage to unsubscribe from topic with success."
            );
        }
    }

    public static async Task<object> WaitForNextNotificationOn<TTopic>(
        this PipeTestClient client,
        TTopic topic,
        TimeSpan? timeout = null,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        var notificationTask = client.Subscriptions[topic].WaitForNextNotification();

        return await PipeTestClient.AwaitWithTimeout(
                notificationTask,
                timeout ?? DefaultNotificationAwaitTimeout,
                ct
            )
            ?? throw new InvalidOperationException(
                "Pipe test client did not receive any notification on topic."
            );
    }

    public static IReadOnlyCollection<object> NotificationsOn<TTopic>(
        this PipeTestClient client,
        TTopic topic
    )
        where TTopic : ITopic
    {
        return client.Subscriptions.GetValueOrDefault(topic)?.ReceivedNotifications
            ?? new List<object>();
    }
}
