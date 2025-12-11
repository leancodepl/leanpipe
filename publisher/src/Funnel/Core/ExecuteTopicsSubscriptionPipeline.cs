using LeanCode.Contracts;

namespace LeanCode.Pipe.Funnel.Core;

public record ExecuteTopicsSubscriptionPipeline(
    SubscriptionEnvelope Envelope,
    OperationType OperationType,
    LeanPipeContext Context
);
