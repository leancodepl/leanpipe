using System.Collections.Immutable;
using System.Text.Json;
using LeanCode.Components;
using LeanCode.Contracts;

namespace LeanCode.Pipe.TestClient;

internal class NotificationEnvelopeDeserializer
{
    private readonly TypesCatalog types;
    private readonly JsonSerializerOptions? options;
    private readonly Lazy<PipeTypes> typesCache;

    public NotificationEnvelopeDeserializer(TypesCatalog types, JsonSerializerOptions? options)
    {
        this.types = types;
        this.options = options;

        typesCache = new(BuildTypesCache);
    }

    public TopicsNotification? Deserialize(NotificationEnvelope envelope)
    {
        if (
            typesCache.Value.Topics.TryGetValue(envelope.TopicType, out var topicType)
            && typesCache.Value.Notifications.TryGetValue(
                envelope.NotificationType,
                out var notificationType
            )
        )
        {
            var topic = (ITopic?)((JsonElement)envelope.Topic).Deserialize(topicType, options);
            var notification = ((JsonElement)envelope.Notification).Deserialize(
                notificationType,
                options
            );

            if (topic is not null && notification is not null)
            {
                return new(topic, notification);
            }
            else
            {
                throw new JsonException(
                    "Failed to deserialize topic or notification from notification envelope."
                );
            }
        }

        return null;
    }

    private PipeTypes BuildTypesCache()
    {
        var topicType = typeof(ITopic);
        var topicTypes = types.Assemblies
            .SelectMany(t => t.ExportedTypes)
            .Where(t => t.IsAssignableTo(topicType) && !t.IsAbstract && !t.IsGenericType)
            .ToImmutableDictionary(t => t.FullName!);

        var produceNotificationType = typeof(IProduceNotification<>);
        var notificationTypes = topicTypes.Values
            .SelectMany(
                t =>
                    t.GetInterfaces()
                        .Where(
                            i =>
                                i.IsGenericType
                                && i.GetGenericTypeDefinition() == produceNotificationType
                        )
                        .Select(i => i.GetGenericArguments()[0])
            )
            .Distinct()
            .ToImmutableDictionary(NotificationTagGenerator.Generate);

        return new(topicTypes, notificationTypes);
    }

    private sealed record PipeTypes(
        ImmutableDictionary<string, Type> Topics,
        ImmutableDictionary<string, Type> Notifications
    );
}

internal sealed record TopicsNotification(ITopic Topic, object Notification);
