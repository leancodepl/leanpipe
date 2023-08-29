using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.LeanPipe;

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
    public static async Task PublishAsync<TTopic, TNotification>(
        this LeanPipePublisher<TTopic> publisher,
        TTopic topic,
        TNotification notification,
        LeanPipeContext context
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var notificationKeys = publisher.ServiceProvider.GetRequiredService<
            INotificationKeys<TTopic, TNotification>
        >();
        var keys = await notificationKeys.GetAsync(topic, notification, context);
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, context.HttpContext.RequestAborted);
    }

    public static async Task PublishAsync<TTopic, TNotification>(
        this LeanPipePublisher<TTopic> publisher,
        string[] keys,
        TTopic topic,
        TNotification notification,
        LeanPipeContext context
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, context.HttpContext.RequestAborted);
    }

    public static async Task PublishToTopicAsync<TTopic, TNotification>(
        this LeanPipePublisher<TTopic> publisher,
        TTopic topic,
        TNotification notification,
        LeanPipeContext context
    )
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var topicKeys = publisher.ServiceProvider.GetRequiredService<ITopicKeys<TTopic>>();
        var keys = await topicKeys.GetAsync(topic, context);
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, context.HttpContext.RequestAborted);
    }
}
