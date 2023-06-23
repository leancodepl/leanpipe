using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public class SubscriptionEnvelope
{
    public string TopicType { get; set; } = default!;
    public object Topic { get; set; } = default!;
}
