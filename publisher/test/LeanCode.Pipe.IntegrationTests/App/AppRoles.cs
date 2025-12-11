using LeanCode.CQRS.Security;

namespace LeanCode.Pipe.IntegrationTests.App;

public class AppRoles : IRoleRegistration
{
    public IEnumerable<Role> Roles { get; } = [new(AuthConfig.Roles.User, AuthConfig.Roles.User)];
}
