using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public class NotificationEnvelope<TTopic, TNotification>
    where TTopic : IProduceNotification<TNotification>
    where TNotification : notnull
{
    public string Topic { get; }
    public string Notification { get; }
    public TTopic Subscription { get; }
    public TNotification Payload { get; }

    public NotificationEnvelope(TTopic topic, TNotification notification)
    {
        Topic = topic.GetType().FullName!;
        Notification = notification.GetType().FullName!;
        Subscription = topic;
        Payload = notification;
    }
}
