using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public class SubscriptionEnvelope
{
    public string TopicType { get; set; } = default!;
    public string Topic { get; set; } = default!;
}
