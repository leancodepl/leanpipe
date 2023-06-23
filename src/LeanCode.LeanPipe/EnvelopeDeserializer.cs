using System.Text.Json;
using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public interface IEnvelopeDeserializer
{
    ITopic Deserialize(SubscriptionEnvelope envelope);
}

public class DefaultEnvelopeDeserializer : IEnvelopeDeserializer
{
    public ITopic Deserialize(SubscriptionEnvelope envelope)
    {
        var topicType =
            Type.GetType(envelope.TopicType)
            ?? throw new NullReferenceException($"Topic type '{envelope.TopicType}' unknown.");
        var options = new JsonSerializerOptions();
        var topic =
            JsonSerializer.Deserialize(envelope.Topic, topicType, options)
            ?? throw new InvalidOperationException($"Cannot deserialize type '{topicType}'.");
        return (ITopic)topic;
    }
}
