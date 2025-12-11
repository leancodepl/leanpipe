using System.Diagnostics.CodeAnalysis;
using System.Text.Json;
using FluentAssertions;
using LeanCode.Contracts;
using Xunit;

namespace LeanCode.Pipe.TestClient.Tests;

public class NotificationEnvelopeDeserializerTests
{
    private static readonly NotificationEnvelopeDeserializer Deserializer = new(
        new(typeof(Topic)),
        null
    );

    [Fact]
    public void NotificationEnvelopeDeserializer_deserializes_topic_and_notification()
    {
        var topic = new Topic { EntityIds = ["Entity1", "Entity2"] };

        var notification = new Notification { EntityId = "Entity1" };

        var notificationEnvelope = NotificationEnvelope.Create(topic, notification);

        var serializedEnvelope = JsonSerializer.Serialize(notificationEnvelope);

        var deserializedEnvelope = JsonSerializer.Deserialize<NotificationEnvelope>(
            serializedEnvelope
        );

        Deserializer
            .Deserialize(deserializedEnvelope!)
            .Should()
            .BeEquivalentTo(new TopicsNotification(topic, notification));
    }

    public class Topic : ITopic, IProduceNotification<Notification>
    {
        [SuppressMessage(
            "Usage",
            "CA2227:Collection properties should be read only",
            Justification = "Not relevant for DTOs."
        )]
        public List<string> EntityIds { get; set; } = default!;
    }

    public class Notification
    {
        public string EntityId { get; set; } = default!;
    }
}
