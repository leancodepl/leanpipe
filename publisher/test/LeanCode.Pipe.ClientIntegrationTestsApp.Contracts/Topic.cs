using LeanCode.Contracts;
using LeanCode.Contracts.Security;

namespace LeanCode.Pipe.ClientIntegrationTestsApp.Contracts;

[AuthorizeWhenHasAnyOf(AuthConfig.Roles.User)]
public class Topic : ITopic, IProduceNotification<NotificationDTO>
{
    public string TopicId { get; set; } = default!;
}

public class NotificationDTO
{
    public string Greeting { get; set; } = default!;
}
