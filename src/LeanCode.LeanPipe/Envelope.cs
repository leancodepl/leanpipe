using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public class Envelope(ITopic topic, object notification)
{
    public string Topic { get; } = topic.GetType().FullName!;
    public string Notification { get; } = notification.GetType().FullName!;
    public ITopic Subscription { get; } = topic;
    public object Payload { get; } = notification;
}
