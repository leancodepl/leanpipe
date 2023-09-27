using System.Collections.Concurrent;
using LeanCode.Contracts;

namespace LeanCode.Pipe.TestClient;

public class LeanPipeSubscription
{
    private readonly object notificationMutex = new();
    private TaskCompletionSource<object> nextMessageAwaiter =
        new(TaskCreationOptions.RunContinuationsAsynchronously);
    private readonly ConcurrentQueue<object> receivedNotifications = new();

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
        receivedNotifications.Enqueue(notification);

        lock (notificationMutex)
        {
            nextMessageAwaiter.TrySetResult(notification);
            nextMessageAwaiter = new(TaskCreationOptions.RunContinuationsAsynchronously);
        }
    }

    public Task<object> WaitForNextNotification()
    {
        lock (notificationMutex)
        {
            return nextMessageAwaiter.Task;
        }
    }
}
