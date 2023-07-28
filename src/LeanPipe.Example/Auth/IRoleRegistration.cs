using LeanCode.CQRS.Security;

namespace LeanPipe.Example.Auth;

public class AppRoles : IRoleRegistration
{
    public IEnumerable<Role> Roles { get; } = new Role[] { new Role("user", "user"), };
}
