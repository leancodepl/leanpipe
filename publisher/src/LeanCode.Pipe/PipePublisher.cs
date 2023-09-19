using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe;

public class PipePublisher<TTopic>
    where TTopic : ITopic
{
    internal IHubContext<PipeSubscriber> HubContext { get; }
    internal IServiceProvider ServiceProvider { get; }

    public PipePublisher(IHubContext<PipeSubscriber> hubContext, IServiceProvider serviceProvider)
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

public static class PipePublisherExtensions
{
    public static async Task PublishAsync<TTopic, TNotification>(
        this PipePublisher<TTopic> publisher,
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

    public static async Task PublishAsync<TTopic, TNotification>(
        this PipePublisher<TTopic> publisher,
        TTopic topic,
        TNotification notification,
        CancellationToken ct = default
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var notificationKeys = publisher.ServiceProvider.GetRequiredService<
            INotificationKeys<TTopic, TNotification>
        >();

        var keys = await notificationKeys.GetForPublishingAsync(topic, notification, ct);
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, ct);
    }

    public static async Task PublishToTopicAsync<TTopic, TNotification>(
        this PipePublisher<TTopic> publisher,
        TTopic topic,
        TNotification notification,
        CancellationToken ct = default
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var topicKeys = publisher.ServiceProvider.GetRequiredService<ITopicKeys<TTopic>>();
        var keys = await topicKeys.GetForPublishingAsync(topic, ct);
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, ct);
    }
}
