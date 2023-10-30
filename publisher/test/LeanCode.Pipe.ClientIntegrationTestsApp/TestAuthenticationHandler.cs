using System.Net.Http.Headers;
using System.Text.Encodings.Web;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;

namespace LeanCode.Pipe.ClientIntegrationTestsApp;

public class TestAuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    public const string SchemeName = "Test authentication";
    public const string CorrectAuthHeaderValue = "1234";

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
                return Task.FromResult(
                    AuthenticateResult.Success(new(AuthConfig.User, SchemeName))
                );
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
