using LeanCode.Contracts;

namespace LeanCode.Pipe.Tests.Additional;

public class TopicWithoutAllKeys
    : ITopic,
        IProduceNotification<Notification1>,
        IProduceNotification<Notification2> { }

public class Notification1 { }

public class Notification2 { }

public class TopicWithoutAllKeysKeys
    : ITopicKeys<TopicWithoutAllKeys>,
        INotificationKeys<TopicWithoutAllKeys, Notification1>
{
    public ValueTask<IEnumerable<string>> GetForSubscribingAsync(
        TopicWithoutAllKeys topic,
        PipeContext context
    )
    {
        return new(Array.Empty<string>());
    }

    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TopicWithoutAllKeys topic,
        CancellationToken ct = default
    )
    {
        return new(Array.Empty<string>());
    }

    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TopicWithoutAllKeys topic,
        Notification1 notification,
        CancellationToken ct = default
    )
    {
        return new(Array.Empty<string>());
    }
}
