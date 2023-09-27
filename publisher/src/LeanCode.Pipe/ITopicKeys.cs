using LeanCode.Contracts;

namespace LeanCode.Pipe;

/// <remarks>
/// Should be implemented in a single class per topic with <see cref="IPublishingKeys{TTopic,TNotification}"/>
/// for all topics notifications.
/// </remarks>
public interface ISubscribingKeys<in TTopic>
    where TTopic : ITopic
{
    /// <summary>
    /// Used to generate SignalR groups keys when client subscribes or unsubscribes.
    /// </summary>
    ValueTask<IEnumerable<string>> GetForSubscribingAsync(TTopic topic, LeanPipeContext context);
}

public interface IPublishingKeys<in TTopic, TNotification> : ISubscribingKeys<TTopic>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    /// <summary>
    /// Used to generate SignalR groups keys to which send message to.
    /// </summary>
    ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TTopic topic,
        TNotification notification,
        CancellationToken ct = default
    );
}
