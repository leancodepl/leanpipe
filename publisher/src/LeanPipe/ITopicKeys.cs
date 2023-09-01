using LeanCode.Contracts;

namespace LeanPipe;

public interface ITopicKeys<in TTopic>
    where TTopic : ITopic
{
    ValueTask<IEnumerable<string>> GetForSubscribingAsync(TTopic topic, LeanPipeContext context);
    ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TTopic topic,
        CancellationToken ct = default
    );
}

public interface INotificationKeys<in TTopic, TNotification> : ITopicKeys<TTopic>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TTopic topic,
        TNotification notification,
        CancellationToken ct = default
    );
}

public abstract class BasicTopicKeys<TTopic> : ITopicKeys<TTopic>
    where TTopic : ITopic
{
    public abstract IEnumerable<string> Get(TTopic topic);

    public ValueTask<IEnumerable<string>> GetForSubscribingAsync(
        TTopic topic,
        LeanPipeContext context
    ) => ValueTask.FromResult(Get(topic));

    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TTopic topic,
        CancellationToken ct = default
    ) => ValueTask.FromResult(Get(topic));
}
