using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public class NotificationEnvelope
{
    public string TopicType { get; private init; } = default!;
    public string NotificationType { get; private init; } = default!;
    public ITopic Topic { get; private init; } = default!;
    public object Notification { get; private init; } = default!;

    public static NotificationEnvelope Create<TTopic, TNotification>(
        TTopic topic,
        TNotification notification
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        return new()
        {
            TopicType = typeof(TTopic).FullName!,
            NotificationType = typeof(TNotification).FullName!,
            Topic = topic,
            Notification = notification,
        };
    }
}
