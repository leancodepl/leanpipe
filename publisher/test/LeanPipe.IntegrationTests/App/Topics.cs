using LeanCode.Contracts;
using LeanCode.Contracts.Security;

namespace LeanPipe.IntegrationTests.App;

[AllowUnauthorized]
public class UnauthorizedTopic
    : ITopic,
        IProduceNotification<GreetingNotificationDTO>,
        IProduceNotification<FarewellNotificationDTO>
{
    public Guid TopicId { get; set; }
}

[AuthorizeWhenHasAnyOf("user")]
public class AuthorizedTopic
    : ITopic,
        IProduceNotification<GreetingNotificationDTO>,
        IProduceNotification<FarewellNotificationDTO>
{
    public Guid TopicId { get; set; }
}

public class GreetingNotificationDTO
{
    public string Greeting { get; set; } = default!;
}

public class FarewellNotificationDTO
{
    public string Farewell { get; set; } = default!;
}
