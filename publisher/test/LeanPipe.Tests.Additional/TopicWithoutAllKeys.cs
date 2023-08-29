using LeanCode.Contracts;

namespace LeanPipe.Tests.Additional;

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
    public ValueTask<IEnumerable<string>> GetAsync(
        TopicWithoutAllKeys topic,
        LeanPipeContext context
    )
    {
        return new(Array.Empty<string>());
    }

    public ValueTask<IEnumerable<string>> GetAsync(
        TopicWithoutAllKeys topic,
        Notification1 notification,
        LeanPipeContext context
    )
    {
        return new(Array.Empty<string>());
    }
}
