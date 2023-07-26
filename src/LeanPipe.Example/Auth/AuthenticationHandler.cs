using System.Text.Encodings.Web;
using Microsoft.AspNetCore.Authentication;
using Microsoft.Extensions.Options;

namespace LeanPipe.Example.Auth;

public class AuthenticationHandler : AuthenticationHandler<AuthenticationSchemeOptions>
{
    public const string SchemeName = "Example";

    public AuthenticationHandler(
        IOptionsMonitor<AuthenticationSchemeOptions> options,
        ILoggerFactory logger,
        UrlEncoder encoder
    )
        : base(options, logger, encoder) { }

    protected override Task<AuthenticateResult> HandleAuthenticateAsync()
    {
        var token = Request.Query["access_token"].FirstOrDefault();

        var claimsPrincipal = token switch
        {
            null => AuthConfig.UserWithoutRole,
            _ => AuthConfig.User,
        };

        var ticket = new AuthenticationTicket(claimsPrincipal, Scheme.Name);

        return Task.FromResult(AuthenticateResult.Success(ticket));
    }
}

public static class AuthenticationHandlerExtensions
{
    public static AuthenticationBuilder AddAuthenticationHandler(
        this AuthenticationBuilder builder,
        Action<AuthenticationSchemeOptions>? config = null
    )
    {
        return builder.AddScheme<AuthenticationSchemeOptions, AuthenticationHandler>(
            AuthenticationHandler.SchemeName,
            config
        );
    }
}
