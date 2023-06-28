namespace LeanCode.LeanPipe;

public class SubscriptionResult
{
    public Guid SubscriptionId { get; private init; }
    public SubscriptionStatus Status { get; private init; }

    public static SubscriptionResult Success(Guid subscriptionId) =>
        new() { SubscriptionId = subscriptionId, Status = SubscriptionStatus.Success };

    public static SubscriptionResult Unauthorized(Guid subscriptionId) =>
        new() { SubscriptionId = subscriptionId, Status = SubscriptionStatus.Unauthorized };

    public static SubscriptionResult Malformed(Guid subscriptionId) =>
        new() { SubscriptionId = subscriptionId, Status = SubscriptionStatus.Malformed };
}

public enum SubscriptionStatus
{
    Success = 0,
    Unauthorized = 1,
    Malformed = 2,
}
