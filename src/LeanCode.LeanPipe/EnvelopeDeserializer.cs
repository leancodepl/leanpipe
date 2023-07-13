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
        // I think we should rather register the types on startup rather than search each time
        // but that's a detail we should take care of later
        var topicType = AppDomain.CurrentDomain
            .GetAssemblies()
            .Select(a => a.GetType(envelope.TopicType))
            .OfType<Type>()
            .First();
        var options = new JsonSerializerOptions();
        var topic =
            JsonSerializer.Deserialize(envelope.Topic, topicType, options)
            ?? throw new NullReferenceException("Topic should not deserialize to null.");
        return (ITopic)topic;
    }
}
