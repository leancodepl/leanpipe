using LeanCode.Contracts;

namespace LeanPipe.TestClient;

public class LeanPipeSubscription
{
    private readonly List<object> receivedNotifications = new();

    public ITopic Topic { get; private init; }
    public Guid? SubscriptionId { get; private set; }
    public TaskCompletionSource<object>? NextMessageAwaiter { get; private set; }
    public IReadOnlyList<object> ReceivedNotifications => receivedNotifications;

    public LeanPipeSubscription(ITopic topic, Guid? subscriptionId)
    {
        Topic = topic;
        SubscriptionId = subscriptionId;
        NextMessageAwaiter = null;
    }

    public void Subscribe(Guid subscriptionId)
    {
        SubscriptionId = subscriptionId;

        ClearMessageAwaiter();
    }

    public void Unsubscribe()
    {
        SubscriptionId = null;

        ClearMessageAwaiter();
    }

    public void AddNotification(object notification)
    {
        receivedNotifications.Add(notification);
        NextMessageAwaiter?.TrySetResult(notification);

        ClearMessageAwaiter();
    }

    public Task<object> GetNextNotificationTask()
    {
        NextMessageAwaiter = new();
        return NextMessageAwaiter.Task;
    }

    private void ClearMessageAwaiter()
    {
        NextMessageAwaiter = null;
    }
}
