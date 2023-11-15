using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text.Encodings.Web;
using LeanCode.Pipe.ClientIntegrationTestsApp.Contracts;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;

namespace LeanCode.Pipe.ClientIntegrationTestsApp;

public class TestAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    public const string SchemeName = "Bearer";
    public const string CorrectAuthHeaderValue = "1234";

    public static readonly Guid UserId = Guid.NewGuid();

    public static readonly ClaimsPrincipal User =
        new(
            new ClaimsIdentity(
                new Claim[]
                {
                    new(AuthConfig.KnownClaims.UserId, UserId.ToString()),
                    new(AuthConfig.KnownClaims.Role, AuthConfig.Roles.User),
                },
                SchemeName,
                AuthConfig.KnownClaims.UserId,
                AuthConfig.KnownClaims.Role
            )
        );

    public TestAuthenticationHandler(
        IOptionsMonitor<AuthenticationSchemeOptions> options,
        ILoggerFactory logger,
        UrlEncoder encoder
    )
        : base(options, logger, encoder) { }

    protected override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        var rawAuth = Request.Headers.Authorization;
        _ = AuthenticationHeaderValue.TryParse(rawAuth, out var auth);

        if (auth?.Scheme == Scheme.Name)
        {
            if (auth.Parameter == CorrectAuthHeaderValue)
            {
                return Task.FromResult(AuthenticateResult.Success(new(User, SchemeName)));
            }
            else
            {
                return Task.FromResult(
                    AuthenticateResult.Fail("Wrong authentication header value.")
                );
            }
        }
        else
        {
            return Task.FromResult(AuthenticateResult.NoResult());
        }
    }
}
