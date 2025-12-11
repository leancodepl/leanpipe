using System.Security.Claims;
using LeanCode.IntegrationTestHelpers;

namespace LeanCode.Pipe.IntegrationTests.App;

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

    public static readonly ClaimsPrincipal User = new(
        new ClaimsIdentity(
            [new(KnownClaims.UserId, UserId.ToString()), new(KnownClaims.Role, Roles.User)],
            TestAuthenticationHandler.SchemeName,
            KnownClaims.UserId,
            KnownClaims.Role
        )
    );

    public static readonly ClaimsPrincipal UserWithoutRole = new(
        new ClaimsIdentity(
            [new(KnownClaims.UserId, UserId.ToString())],
            TestAuthenticationHandler.SchemeName,
            KnownClaims.UserId,
            KnownClaims.Role
        )
    );
}
