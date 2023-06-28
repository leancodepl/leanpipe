using System.Text.Json;
using LeanCode.Contracts;
using LeanCode.LeanPipe;

namespace LeanPipe.Example.Handlers;

public class EnvelopeDeserializer : IEnvelopeDeserializer
{
    public ITopic Deserialize(SubscriptionEnvelope envelope)
    {
        // this class is just vendored from LeanPipe as a quick workaround
        // because Type.GetType only works easily for current assembly
        // and I don't want to fiddle with his right now
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
