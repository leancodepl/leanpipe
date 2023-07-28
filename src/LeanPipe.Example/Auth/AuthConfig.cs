using System.Security.Claims;

namespace LeanPipe.Example.Auth;

public static class AuthConfig
{
    public static readonly Guid UserId = Guid.NewGuid();

    public static readonly ClaimsPrincipal User =
        new(
            new ClaimsIdentity(
                new Claim[] { new("sub", UserId.ToString()), new("role", "user") },
                AuthenticationHandler.SchemeName,
                "sub",
                "role"
            )
        );

    public static readonly ClaimsPrincipal UserWithoutRole =
        new(
            new ClaimsIdentity(
                new Claim[] { new("sub", UserId.ToString()) },
                AuthenticationHandler.SchemeName,
                "sub",
                "role"
            )
        );
}
