using LeanCode.Contracts;
using LeanCode.Contracts.Security;

namespace LeanCode.Pipe.IntegrationTests.App;

[AllowUnauthorized]
public class BasicTopic
    : ITopic,
        IProduceNotification<GreetingNotificationDTO>,
        IProduceNotification<FarewellNotificationDTO>
{
    public Guid TopicId { get; set; }
}

[AuthorizeWhenHasAnyOf(AuthConfig.Roles.User)]
public class AuthorizedTopic
    : ITopic,
        IProduceNotification<GreetingNotificationDTO>,
        IProduceNotification<FarewellNotificationDTO>
{
    public Guid TopicId { get; set; }
}

[AllowUnauthorized]
public class EmptyTopic : ITopic { }

public class GreetingNotificationDTO
{
    public string Greeting { get; set; } = default!;
}

public class FarewellNotificationDTO
{
    public string Farewell { get; set; } = default!;
}
