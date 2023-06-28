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
        // I think we should rather register the types on startup rather than search each time
        // but that's a detail we should take care of later
        var topicType = AppDomain.CurrentDomain
            .GetAssemblies()
            .Select(a => a.GetType(envelope.TopicType))
            .OfType<Type>()
            .FirstOrDefault();
        var options = new JsonSerializerOptions();
        try
        {
            var topic = topicType is not null
                ? JsonSerializer.Deserialize(envelope.Topic, topicType, options)
                : null;
            return (ITopic?)topic;
        }
        catch
        {
            // TODO: log what's wrong
            return null;
        }
    }
}
