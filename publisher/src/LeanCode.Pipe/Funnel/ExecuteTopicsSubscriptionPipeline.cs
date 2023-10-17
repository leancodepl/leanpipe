using LeanCode.Contracts;

namespace LeanCode.Pipe.Funnel;

public record ExecuteTopicsSubscriptionPipeline(
    SubscriptionEnvelope Envelope,
    OperationType OperationType,
    LeanPipeContext Context
);
