using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.LeanPipe;

public class LeanPipePublisher<TTopic>
    where TTopic : ITopic
{
    internal IHubContext<LeanPipeSubscriber> HubContext { get; }
    internal ITopicController<TTopic> TopicController { get; }
    internal IServiceProvider ServiceProvider { get; }

    public LeanPipePublisher(
        IHubContext<LeanPipeSubscriber> hubContext,
        ITopicController<TTopic> topicController,
        IServiceProvider serviceProvider
    )
    {
        HubContext = hubContext;
        TopicController = topicController;
        ServiceProvider = serviceProvider;
    }

    internal async Task PublishAsync(
        IEnumerable<string> keys,
        NotificationEnvelope payload,
        CancellationToken cancellationToken = default)
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
        LeanPipeContext context)
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var topicController = publisher.ServiceProvider.GetRequiredService<ITopicController<TTopic, TNotification>>();
        var keys = await topicController.ToKeysAsync(topic, notification, context);
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, context.Context.RequestAborted);
    }

    public static async Task PublishAsync<TTopic, TNotification>(
        this LeanPipePublisher<TTopic> publisher,
        string[] keys,
        TTopic topic,
        TNotification notification,
        LeanPipeContext context)
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, context.Context.RequestAborted);
    }

    public static async Task PublishToTopicAsync<TTopic, TNotification>(
        this LeanPipePublisher<TTopic> publisher,
        TTopic topic,
        TNotification notification,
        LeanPipeContext context)
        where TTopic : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        var keys = await publisher.TopicController.ToKeysAsync(topic, context);
        var payload = NotificationEnvelope.Create(topic, notification);

        await publisher.PublishAsync(keys, payload, context.Context.RequestAborted);
    }
}
