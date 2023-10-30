using LeanCode.CQRS.Security;

namespace LeanCode.Pipe.ClientIntegrationTestsApp;

public class AppRoles : IRoleRegistration
{
    public IEnumerable<Role> Roles { get; } =
        new Role[] { new(AuthConfig.Roles.User, AuthConfig.Roles.User) };
}
