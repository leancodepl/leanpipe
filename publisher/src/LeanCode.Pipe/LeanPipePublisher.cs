using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe;

/// <summary>
/// Allows publishing notifications to instances of TTopic.
/// Conveniently used with extension methods from <see cref="LeanPipePublisherExtensions"/>.
/// </summary>
public interface ILeanPipePublisher<TTopic>
    where TTopic : ITopic
{
    IPublishingKeys<T, TNotification> GetPublishingKeysProvider<T, TNotification>()
        where T : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull;

    Task PublishAsync(
        IEnumerable<string> keys,
        NotificationEnvelope payload,
        CancellationToken cancellationToken = default
    );
}

internal class LeanPipePublisher<TTopic> : ILeanPipePublisher<TTopic>
    where TTopic : ITopic
{
    private readonly Serilog.ILogger logger;

    private IHubContext<LeanPipeSubscriber> HubContext { get; }
    private IServiceProvider ServiceProvider { get; }

    public LeanPipePublisher(
        IHubContext<LeanPipeSubscriber> hubContext,
        IServiceProvider serviceProvider
    )
    {
        logger = Serilog.Log.ForContext(GetType());
        HubContext = hubContext;
        ServiceProvider = serviceProvider;
    }

    public IPublishingKeys<T, TNotification> GetPublishingKeysProvider<T, TNotification>()
        where T : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        return ServiceProvider.GetRequiredService<IPublishingKeys<T, TNotification>>();
    }

    public async Task PublishAsync(
        IEnumerable<string> keys,
        NotificationEnvelope payload,
        CancellationToken cancellationToken = default
    )
    {
        await HubContext.Clients
            .Groups(keys)
            .SendAsync("notify", payload, cancellationToken)
            .ConfigureAwait(false);

        logger.Information(
            "Published notification {NotificationType} to {GroupCount} groups of topic {TopicType}",
            payload.NotificationType,
            keys.Count(),
            payload.TopicType
        );
    }
}

public static class LeanPipePublisherExtensions
{
    /// <summary>
    /// Publishes to topic instance using provided SignalR groups keys.
    /// Ignores publishing keys implemented in <see cref="IPublishingKeys{TTopic,TNotification}"/>.
    /// </summary>
    /// <remarks>Does not wait for a response from the receivers.</remarks>
    public static async Task PublishAsync<TTopic, TNotification>(
        this ILeanPipePublisher<TTopic> publisher,
        IEnumerable<string> keys,
        TTopic topic,
        TNotification notification,
        CancellationToken ct = default
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, ct).ConfigureAwait(false);
    }

    /// <summary>
    /// Publishes to topic instance using SignalR groups keys generated via implementation of
    /// <see cref="IPublishingKeys{TTopic,TNotification}"/>.
    /// </summary>
    /// <remarks>Does not wait for a response from the receivers.</remarks>
    public static async Task PublishAsync<TTopic, TNotification>(
        this ILeanPipePublisher<TTopic> publisher,
        TTopic topic,
        TNotification notification,
        CancellationToken ct = default
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var publishingKeysProvider = publisher.GetPublishingKeysProvider<TTopic, TNotification>();

        var keys = await publishingKeysProvider
            .GetForPublishingAsync(topic, notification, ct)
            .ConfigureAwait(false);
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, ct).ConfigureAwait(false);
    }
}
