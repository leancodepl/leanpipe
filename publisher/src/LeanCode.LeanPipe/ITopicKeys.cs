using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public interface ITopicKeys<in TTopic>
    where TTopic : ITopic
{
    ValueTask<IEnumerable<string>> GetAsync(TTopic topic, LeanPipeContext context);
}

public interface INotificationKeys<in TTopic, TNotification> : ITopicKeys<TTopic>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    ValueTask<IEnumerable<string>> GetAsync(
        TTopic topic,
        TNotification notification,
        LeanPipeContext context
    );
}

public abstract class BasicTopicKeys<TTopic> : ITopicKeys<TTopic>
    where TTopic : ITopic
{
    public abstract IEnumerable<string> Get(TTopic topic);

    public ValueTask<IEnumerable<string>> GetAsync(TTopic topic, LeanPipeContext context) =>
        ValueTask.FromResult(Get(topic));
}
