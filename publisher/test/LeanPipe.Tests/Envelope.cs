using System.Text.Json;
using LeanCode.Contracts;

namespace LeanPipe.Tests;

public static class Envelope
{
    public static SubscriptionEnvelope Empty<T>()
    {
        return new()
        {
            Id = Guid.NewGuid(),
            TopicType = typeof(T).FullName!,
            Topic = JsonDocument.Parse("{}"),
        };
    }
}
