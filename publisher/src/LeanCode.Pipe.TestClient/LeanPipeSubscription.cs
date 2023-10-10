using System.Collections.Concurrent;
using System.Runtime.CompilerServices;
using System.Threading.Channels;
using LeanCode.Contracts;

namespace LeanCode.Pipe.TestClient;

public class LeanPipeSubscription
{
    public static readonly TimeSpan DefaultNotificationAwaitTimeout = TimeSpan.FromSeconds(10);

    private readonly object notificationMutex = new();

    private readonly ConcurrentQueue<object> receivedNotifications = new();
    private Action<object> onNotification = _ => { };

    public ITopic Topic { get; private init; }
    public Guid? SubscriptionId { get; private set; }

    /// <summary>
    /// A FIFO collection of received notifications.
    /// </summary>
    public IReadOnlyCollection<object> ReceivedNotifications => receivedNotifications;

    public LeanPipeSubscription(ITopic topic, Guid? subscriptionId)
    {
        Topic = topic;
        SubscriptionId = subscriptionId;
    }

    public void Subscribe(Guid subscriptionId)
    {
        SubscriptionId = subscriptionId;
    }

    public void Unsubscribe()
    {
        SubscriptionId = null;
    }

    public void AddNotification(object notification)
    {
        lock (notificationMutex)
        {
            receivedNotifications.Enqueue(notification);
            onNotification(notification);
        }
    }

    public async ValueTask<object> WaitForNextNotification(
        Func<object, bool>? notificationPredicate = null,
        TimeSpan? timeout = null,
        CancellationToken ct = default
    )
    {
        notificationPredicate ??= _ => true;

        using var cts = CancellationTokenSource.CreateLinkedTokenSource(ct);
        cts.CancelAfter(timeout ?? DefaultNotificationAwaitTimeout);

        await foreach (var n in NotificationStreamAsync().WithCancellation(cts.Token))
        {
            if (notificationPredicate(n))
            {
                return n;
            }
        }

        throw new InvalidOperationException(
            "No notification satisfies the condition in the predicate."
        );
    }

    public async IAsyncEnumerable<object> NotificationStreamWithPreviousNotificationsAsync(
        [EnumeratorCancellation] CancellationToken ct = default
    )
    {
        List<object> previousNotifications;
        IAsyncEnumerable<object> futureNotificationsStream;

        lock (notificationMutex)
        {
            previousNotifications = receivedNotifications.ToList();
            futureNotificationsStream = NotificationStreamAsync();
        }

        foreach (var n in previousNotifications)
        {
            yield return n;
        }

        await foreach (var n in futureNotificationsStream.WithCancellation(ct))
        {
            yield return n;
        }
    }

    public IAsyncEnumerable<object> NotificationStreamAsync()
    {
        var channel = Channel.CreateUnbounded<object>(
            new()
            {
                SingleWriter = true,
                SingleReader = false,
                AllowSynchronousContinuations = false,
            }
        );

        onNotification += WriteNotificationToChannel(channel);

        return channel.Reader.ReadAllAsync();

        static Action<object> WriteNotificationToChannel(Channel<object> c) =>
            n => c.Writer.TryWrite(n);
    }
}
