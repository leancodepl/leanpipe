using LeanCode.Contracts;

namespace LeanCode.Pipe.TestClient;

public static class LeanPipeTestClientExtensions
{
    private static readonly TimeSpan DefaultNotificationAwaitTimeout = TimeSpan.FromSeconds(10);

    /// <summary>
    /// Subscribe to a topic instance or throw if it fails for any reason.
    /// </summary>
    /// <param name="topic">Topic instance to subscribe to.</param>
    /// <returns>Subscription ID.</returns>
    /// <exception cref="InvalidOperationException">The subscription failed for any reason.</exception>
    public static async Task<Guid> SubscribeSuccessAsync<TTopic>(
        this LeanPipeTestClient client,
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
                "LeanPipe test client did not manage to subscribe to topic with success."
            );
        }
    }

    /// <summary>
    /// Unsubscribe from a topic instance or throw if it fails for any reason.
    /// </summary>
    /// <param name="topic">Topic instance to unsubscribe from.</param>
    /// <returns>Subscription ID.</returns>
    /// <exception cref="InvalidOperationException">The unsubscription failed for any reason.</exception>
    public static async Task<Guid> UnsubscribeSuccessAsync<TTopic>(
        this LeanPipeTestClient client,
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
                "LeanPipe test client did not manage to unsubscribe from topic with success."
            );
        }
    }

    /// <summary>
    /// Returns a task, which completes when the next notification on the topic is received.
    /// </summary>
    /// <remarks>
    /// The task should be collected before the action which triggers notification publish
    /// and awaited after the trigger.
    /// Otherwise there is a possibility that the notification after the expected one is awaited.</remarks>
    /// <param name="topic">Topic instance on which notification is to be awaited.</param>
    /// <param name="timeout">Timeout after which the notification is assumed to be not delivered.</param>
    /// <returns>Task containing received notification.</returns>
    /// <exception cref="InvalidOperationException">The topic instance received no notifications during the timeout.</exception>
    public static async Task<object> WaitForNextNotificationOn<TTopic>(
        this LeanPipeTestClient client,
        TTopic topic,
        TimeSpan? timeout = null,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        var notificationTask = client.Subscriptions[topic].WaitForNextNotification();

        return await LeanPipeTestClient.AwaitWithTimeout(
                notificationTask,
                timeout ?? DefaultNotificationAwaitTimeout,
                ct
            )
            ?? throw new InvalidOperationException(
                "LeanPipe test client did not receive any notification on topic."
            );
    }

    /// <returns>A FIFO collection of received notifications on topic instance.</returns>
    public static IReadOnlyCollection<object> NotificationsOn<TTopic>(
        this LeanPipeTestClient client,
        TTopic topic
    )
        where TTopic : ITopic
    {
        return client.Subscriptions.GetValueOrDefault(topic)?.ReceivedNotifications
            ?? new List<object>();
    }
}
