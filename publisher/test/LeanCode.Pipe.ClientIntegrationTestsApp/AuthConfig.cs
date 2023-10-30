using System.Security.Claims;

namespace LeanCode.Pipe.ClientIntegrationTestsApp;

public static class AuthConfig
{
    public static class Roles
    {
        public const string User = "user";
    }

    public static class KnownClaims
    {
        public const string UserId = "sub";
        public const string Role = "role";
    }

    public static readonly Guid UserId = Guid.NewGuid();

    public static readonly ClaimsPrincipal User =
        new(
            new ClaimsIdentity(
                new Claim[]
                {
                    new(KnownClaims.UserId, UserId.ToString()),
                    new(KnownClaims.Role, Roles.User),
                },
                TestAuthenticationHandler.SchemeName,
                KnownClaims.UserId,
                KnownClaims.Role
            )
        );
}
