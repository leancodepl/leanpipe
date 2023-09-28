using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe;

/// <summary>
/// Allows publishing notifications to instances of TTopic.
/// Conveniently used with extension methods from <see cref="LeanPipePublisherExtensions"/>.
/// </summary>
public class LeanPipePublisher<TTopic>
    where TTopic : ITopic
{
    internal IHubContext<LeanPipeSubscriber> HubContext { get; }
    internal IServiceProvider ServiceProvider { get; }

    public LeanPipePublisher(
        IHubContext<LeanPipeSubscriber> hubContext,
        IServiceProvider serviceProvider
    )
    {
        HubContext = hubContext;
        ServiceProvider = serviceProvider;
    }

    internal async Task PublishAsync(
        IEnumerable<string> keys,
        NotificationEnvelope payload,
        CancellationToken cancellationToken = default
    )
    {
        await HubContext.Clients.Groups(keys).SendAsync("notify", payload, cancellationToken);
    }
}

public static class LeanPipePublisherExtensions
{
    /// <summary>
    /// Publishes to topic instance using provided SignalR groups keys.
    /// Ignores publishing keys implemented in <see cref="IPublishingKeys{TTopic,TNotification}"/>.
    /// </summary>
    public static async Task PublishAsync<TTopic, TNotification>(
        this LeanPipePublisher<TTopic> publisher,
        IEnumerable<string> keys,
        TTopic topic,
        TNotification notification,
        CancellationToken ct = default
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, ct);
    }

    /// <summary>
    /// Publishes to topic instance using SignalR groups keys generated via implementation of
    /// <see cref="IPublishingKeys{TTopic,TNotification}"/>.
    /// </summary>
    public static async Task PublishAsync<TTopic, TNotification>(
        this LeanPipePublisher<TTopic> publisher,
        TTopic topic,
        TNotification notification,
        CancellationToken ct = default
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var notificationKeys = publisher.ServiceProvider.GetRequiredService<
            IPublishingKeys<TTopic, TNotification>
        >();

        var keys = await notificationKeys.GetForPublishingAsync(topic, notification, ct);
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, ct);
    }
}
