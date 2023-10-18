using System.Collections.Immutable;
using System.Text.Json;
using LeanCode.Components;
using LeanCode.Contracts;

namespace LeanCode.Pipe;

public interface IEnvelopeDeserializer
{
    ITopic? Deserialize(SubscriptionEnvelope envelope);
    bool TopicExists(string topicType);
}

public class DefaultEnvelopeDeserializer : IEnvelopeDeserializer
{
    private readonly TypesCatalog types;
    private readonly JsonSerializerOptions? options;
    private readonly Lazy<ImmutableDictionary<string, Type>> topicTypes;

    public DefaultEnvelopeDeserializer(TypesCatalog types, JsonSerializerOptions? options)
    {
        this.types = types;
        this.options = options;

        topicTypes = new(BuildCache);
    }

    public ITopic? Deserialize(SubscriptionEnvelope envelope)
    {
        if (topicTypes.Value.TryGetValue(envelope.TopicType, out var topicType))
        {
            return (ITopic?)envelope.Topic.Deserialize(topicType, options);
        }
        else
        {
            return null;
        }
    }

    public bool TopicExists(string topicType) => topicTypes.Value.ContainsKey(topicType);

    private ImmutableDictionary<string, Type> BuildCache()
    {
        var topicType = typeof(ITopic);
        return types.Assemblies
            .SelectMany(t => t.ExportedTypes)
            .Where(t => t.IsAssignableTo(topicType) && !t.IsAbstract && !t.IsGenericType)
            .ToImmutableDictionary(t => t.FullName!, StringComparer.InvariantCulture);
    }
}
