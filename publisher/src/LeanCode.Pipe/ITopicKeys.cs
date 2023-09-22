using LeanCode.Contracts;

namespace LeanCode.Pipe;

public interface ISubscribingKeys<in TTopic>
    where TTopic : ITopic
{
    ValueTask<IEnumerable<string>> GetForSubscribingAsync(TTopic topic, LeanPipeContext context);
}

public interface IPublishingKeys<in TTopic, TNotification> : ISubscribingKeys<TTopic>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TTopic topic,
        TNotification notification,
        CancellationToken ct = default
    );
}
