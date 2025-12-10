using LeanCode.Contracts;

namespace LeanCode.Pipe.Funnel.Core;

public record SubscriptionPipelineResult(SubscriptionStatus Status, List<string> GroupKeys);
