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
    /// <exception cref="TimeoutException">No result was received within set timeout.</exception>
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
    /// <exception cref="TimeoutException">No result was received within set timeout.</exception>
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
    /// <exception cref="TimeoutException">The topic instance received no notifications before the timeout.</exception>
    public static Task<object> WaitForNextNotificationOn<TTopic>(
        this LeanPipeTestClient client,
        TTopic topic,
        Func<object, bool>? notificationPredicate = null,
        TimeSpan? timeout = null,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        notificationPredicate ??= _ => true;

        return WaitAsync();

        async Task<object> WaitAsync()
        {
            object msg;

            using var cts = CancellationTokenSource.CreateLinkedTokenSource(ct);
            cts.CancelAfter(timeout ?? DefaultNotificationAwaitTimeout);

            while (
                !notificationPredicate(
                    msg = await client.Subscriptions[topic].WaitForNextNotification(cts.Token)
                )
            ) { }

            return msg;
        }
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
        where TTopic : ITopic, IProduceNotification<TNotification>
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
}
