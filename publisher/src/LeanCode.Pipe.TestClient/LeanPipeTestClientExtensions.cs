using LeanCode.Contracts;

namespace LeanCode.Pipe.TestClient;

public static class LeanPipeTestClientExtensions
{
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
            subscriptionResult.Type == OperationType.Subscribe
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
            subscriptionResult.Type == OperationType.Unsubscribe
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
    /// Returns a task, which completes when subscription on the topic receives next notification satisfying the predicate.
    /// </summary>
    /// <remarks>
    /// The task should be collected before the action that triggers the notification to be published
    /// and it should be awaited after the triggering event. Otherwise there is a possibility that
    /// the awaited notification is a notification subsequent to the expected one.
    /// </remarks>
    /// <param name="topic">Topic instance, on which notification is to be awaited.</param>
    /// <param name="notificationPredicate">Specifies notification to wait for.</param>
    /// <param name="timeout">Timeout, after which the notification is assumed to be not delivered.</param>
    /// <returns>Task containing the received notification.</returns>
    public static ValueTask<object> WaitForNextNotificationOn<TTopic>(
        this LeanPipeTestClient client,
        TTopic topic,
        Func<object, bool>? notificationPredicate = null,
        TimeSpan? timeout = null,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        return client.Subscriptions[topic].WaitForNextNotification(
            notificationPredicate,
            timeout,
            ct
        );
    }

    /// <inheritdoc cref="WaitForNextNotificationOn{TTopic}"/>
    /// <summary>
    /// Returns a task, which completes when subscription on the topic receives next notification of the specified type,
    /// satisfying the predicate.
    /// </summary>
    public static async Task<TNotification> WaitForNextNotificationOn<TTopic, TNotification>(
        this LeanPipeTestClient client,
        TTopic topic,
        Func<TNotification, bool>? notificationPredicate = null,
        TimeSpan? timeout = null,
        CancellationToken ct = default
    )
        where TTopic : ITopic
        where TNotification : notnull
    {
        notificationPredicate ??= _ => true;

        return (TNotification)
            await WaitForNextNotificationOn(
                client,
                topic,
                NotificationAndTypePredicate,
                timeout,
                ct
            );

        bool NotificationAndTypePredicate(object n) =>
            n is TNotification tn && notificationPredicate(tn);
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

    public static IAsyncEnumerable<object> FutureNotificationsOnAsync<TTopic>(
        this LeanPipeTestClient client,
        TTopic topic
    )
        where TTopic : ITopic
    {
        return client.Subscriptions.GetValueOrDefault(topic)?.NotificationStreamAsync()
            ?? AsyncEnumerable.Empty<object>();
    }

    public static IAsyncEnumerable<object> AllNotificationsOnAsync<TTopic>(
        this LeanPipeTestClient client,
        TTopic topic
    )
        where TTopic : ITopic
    {
        if (client.Subscriptions.TryGetValue(topic, out var subscription))
        {
            return subscription.ReceivedNotifications
                .ToList()
                .ToAsyncEnumerable()
                .Concat(subscription.NotificationStreamAsync());
        }
        else
        {
            return AsyncEnumerable.Empty<object>();
        }
    }
}
