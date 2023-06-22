using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public class Envelope(ITopic topic, INotification notification)
{
    public string Topic { get; } = topic.GetType().Name;
    public string Notification { get; } = notification.GetType().Name;
    public ITopic Subscription { get; } = topic;
    public INotification Payload { get; } = notification;
}
