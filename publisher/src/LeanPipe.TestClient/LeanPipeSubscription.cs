using System.Collections.Concurrent;
using LeanCode.Contracts;

namespace LeanPipe.TestClient;

public class LeanPipeSubscription
{
    private TaskCompletionSource<object> nextMessageAwaiter = new();
    private readonly ConcurrentStack<object> receivedNotifications = new();

    public ITopic Topic { get; private init; }
    public Guid? SubscriptionId { get; private set; }
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
        receivedNotifications.Push(notification);
        nextMessageAwaiter.TrySetResult(notification);
        nextMessageAwaiter = new();
    }

    public Task<object> WaitForNextNotification()
    {
        return nextMessageAwaiter.Task;
    }
}
