using LeanCode.Contracts;

namespace LeanCode.Pipe;

/// <summary>
/// Convenience class for implementing topic keys for simple topics.
/// </summary>
/// <typeparam name="TT">Topic</typeparam>
public abstract class BasicTopicKeys<TT> : ISubscribingKeys<TT>
    where TT : ITopic
{
    /// <summary>
    /// Used to generate SignalR groups keys when client subscribes, unsubscribes
    /// or when the message is published.
    /// </summary>
    public abstract IEnumerable<string> Get(TT topic);

    public ValueTask<IEnumerable<string>> GetForSubscribingAsync(
        TT topic,
        LeanPipeContext context
    ) => ValueTask.FromResult(Get(topic));
}

/// <inheritdoc cref="BasicTopicKeys{TT}"/>
public abstract class BasicTopicKeys<TT, TN1> : IPublishingKeys<TT, TN1>
    where TT : ITopic, IProduceNotification<TN1>
    where TN1 : notnull
{
    /// <inheritdoc cref="BasicTopicKeys{TT}.Get"/>
    public abstract IEnumerable<string> Get(TT topic);

    public ValueTask<IEnumerable<string>> GetForSubscribingAsync(
        TT topic,
        LeanPipeContext context
    ) => ValueTask.FromResult(Get(topic));

    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TT topic,
        TN1 notification,
        CancellationToken ct
    ) => ValueTask.FromResult(Get(topic));
}

/// <inheritdoc cref="BasicTopicKeys{TT}"/>
public abstract class BasicTopicKeys<TT, TN1, TN2>
    : BasicTopicKeys<TT, TN1>,
        IPublishingKeys<TT, TN2>
    where TT : ITopic, IProduceNotification<TN1>, IProduceNotification<TN2>
    where TN1 : notnull
    where TN2 : notnull
{
    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TT topic,
        TN2 notification,
        CancellationToken ct = default
    ) => ValueTask.FromResult(Get(topic));
}

/// <inheritdoc cref="BasicTopicKeys{TT}"/>
public abstract class BasicTopicKeys<TT, TN1, TN2, TN3>
    : BasicTopicKeys<TT, TN1, TN2>,
        IPublishingKeys<TT, TN3>
    where TT : ITopic,
        IProduceNotification<TN1>,
        IProduceNotification<TN2>,
        IProduceNotification<TN3>
    where TN1 : notnull
    where TN2 : notnull
    where TN3 : notnull
{
    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TT topic,
        TN3 notification,
        CancellationToken ct = default
    ) => ValueTask.FromResult(Get(topic));
}

/// <inheritdoc cref="BasicTopicKeys{TT}"/>
public abstract class BasicTopicKeys<TT, TN1, TN2, TN3, TN4>
    : BasicTopicKeys<TT, TN1, TN2, TN3>,
        IPublishingKeys<TT, TN4>
    where TT : ITopic,
        IProduceNotification<TN1>,
        IProduceNotification<TN2>,
        IProduceNotification<TN3>,
        IProduceNotification<TN4>
    where TN1 : notnull
    where TN2 : notnull
    where TN3 : notnull
    where TN4 : notnull
{
    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TT topic,
        TN4 notification,
        CancellationToken ct = default
    ) => ValueTask.FromResult(Get(topic));
}

/// <inheritdoc cref="BasicTopicKeys{TT}"/>
public abstract class BasicTopicKeys<TT, TN1, TN2, TN3, TN4, TN5>
    : BasicTopicKeys<TT, TN1, TN2, TN3, TN4>,
        IPublishingKeys<TT, TN5>
    where TT : ITopic,
        IProduceNotification<TN1>,
        IProduceNotification<TN2>,
        IProduceNotification<TN3>,
        IProduceNotification<TN4>,
        IProduceNotification<TN5>
    where TN1 : notnull
    where TN2 : notnull
    where TN3 : notnull
    where TN4 : notnull
    where TN5 : notnull
{
    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TT topic,
        TN5 notification,
        CancellationToken ct = default
    ) => ValueTask.FromResult(Get(topic));
}

/// <inheritdoc cref="BasicTopicKeys{TT}"/>
public abstract class BasicTopicKeys<TT, TN1, TN2, TN3, TN4, TN5, TN6>
    : BasicTopicKeys<TT, TN1, TN2, TN3, TN4, TN5>,
        IPublishingKeys<TT, TN6>
    where TT : ITopic,
        IProduceNotification<TN1>,
        IProduceNotification<TN2>,
        IProduceNotification<TN3>,
        IProduceNotification<TN4>,
        IProduceNotification<TN5>,
        IProduceNotification<TN6>
    where TN1 : notnull
    where TN2 : notnull
    where TN3 : notnull
    where TN4 : notnull
    where TN5 : notnull
    where TN6 : notnull
{
    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TT topic,
        TN6 notification,
        CancellationToken ct = default
    ) => ValueTask.FromResult(Get(topic));
}

/// <inheritdoc cref="BasicTopicKeys{TT}"/>
public abstract class BasicTopicKeys<TT, TN1, TN2, TN3, TN4, TN5, TN6, TN7>
    : BasicTopicKeys<TT, TN1, TN2, TN3, TN4, TN5, TN6>,
        IPublishingKeys<TT, TN7>
    where TT : ITopic,
        IProduceNotification<TN1>,
        IProduceNotification<TN2>,
        IProduceNotification<TN3>,
        IProduceNotification<TN4>,
        IProduceNotification<TN5>,
        IProduceNotification<TN6>,
        IProduceNotification<TN7>
    where TN1 : notnull
    where TN2 : notnull
    where TN3 : notnull
    where TN4 : notnull
    where TN5 : notnull
    where TN6 : notnull
    where TN7 : notnull
{
    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        TT topic,
        TN7 notification,
        CancellationToken ct = default
    ) => ValueTask.FromResult(Get(topic));
}
