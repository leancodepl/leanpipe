using LeanCode.CQRS.Security;
using LeanCode.Pipe.ClientIntegrationTestsApp.Contracts;

namespace LeanCode.Pipe.ClientIntegrationTestsApp;

public class AppRoles : IRoleRegistration
{
    public IEnumerable<Role> Roles { get; } =
        new Role[] { new(AuthConfig.Roles.User, AuthConfig.Roles.User) };
}
