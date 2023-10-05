using LeanCode.Contracts;

namespace LeanCode.Pipe.Funnel;

public record SubscriptionPipelineResult(SubscriptionStatus Status, List<string> GroupKeys);
