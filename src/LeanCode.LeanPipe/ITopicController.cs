using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

/// <summary>
/// Marker interface, do not use directly
/// </summary>
public interface ITopicController<in TTopic>
    where TTopic : ITopic
{
    ValueTask<IEnumerable<string>> ToKeysAsync(TTopic topic, LeanPipeContext context);
}

public interface ITopicController<in TTopic, TNotification> : ITopicController<TTopic>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    ValueTask<IEnumerable<string>> ToKeysAsync(
        TTopic topic,
        TNotification notification,
        LeanPipeContext context
    );
}

public abstract class BasicTopicController<TTopic> : ITopicController<TTopic>
    where TTopic : ITopic
{
    public abstract IEnumerable<string> ToKeys(TTopic topic);

    public ValueTask<IEnumerable<string>> ToKeysAsync(TTopic topic, LeanPipeContext context) =>
        ValueTask.FromResult(ToKeys(topic));
}
