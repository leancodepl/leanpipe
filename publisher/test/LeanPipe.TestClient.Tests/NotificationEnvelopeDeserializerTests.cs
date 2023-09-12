using System.Text.Json;
using FluentAssertions;
using LeanCode.Contracts;
using Xunit;

namespace LeanPipe.TestClient.Tests;

public class NotificationEnvelopeDeserializerTests
{
    private static readonly NotificationEnvelopeDeserializer Deserializer =
        new(new(typeof(Topic)), null);

    [Fact]
    public void NotificationEnvelopeDeserializer_deserializes_topic_and_notification()
    {
        var topic = new Topic
        {
            EntityIds = new() { "Entity1", "Entity2" },
        };

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
        public List<string> EntityIds { get; set; } = default!;
    }

    public class Notification
    {
        public string EntityId { get; set; } = default!;
    }
}
