using System.Text.Json;
using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public interface IEnvelopeDeserializer
{
    ITopic? Deserialize(SubscriptionEnvelope envelope);
}

public class DefaultEnvelopeDeserializer : IEnvelopeDeserializer
{
    public ITopic? Deserialize(SubscriptionEnvelope envelope)
    {
        // Type.GetType only works easily for current assembly
        // so we'll need to change this
        var topicType = Type.GetType(envelope.TopicType);
        var options = new JsonSerializerOptions();
        var topic = topicType is not null
            ? JsonSerializer.Deserialize(envelope.Topic, topicType, options)
            : null;
        return (ITopic?)topic;
    }
}
