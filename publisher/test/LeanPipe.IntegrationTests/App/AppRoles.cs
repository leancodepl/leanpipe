using LeanCode.CQRS.Security;

namespace LeanPipe.IntegrationTests.App;

public class AppRoles : IRoleRegistration
{
    public IEnumerable<Role> Roles { get; } = new Role[] { new("user", "user"), };
}
