using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public class NotificationEnvelope(ITopic topic, object notification)
{
    public string TopicType { get; } = topic.GetType().FullName!;
    public string NotificationType { get; } = notification.GetType().FullName!;
    public ITopic Topic { get; } = topic;
    public object Notification { get; } = notification;
}
