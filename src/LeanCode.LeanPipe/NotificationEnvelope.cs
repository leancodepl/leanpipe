using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public class NotificationEnvelope<TTopic, TNotification>(TTopic topic, TNotification notification)
	where TTopic: IProduceNotification<TNotification>
    where TNotification : notnull
{
    public string Topic { get; } = topic.GetType().FullName!;
    public string Notification { get; } = notification.GetType().FullName!;
    public TTopic Subscription { get; } = topic;
    public TNotification Payload { get; } = notification;
}
