using System.Net.Http.Headers;
using LeanCode.IntegrationTestHelpers;
using LeanPipe.IntegrationTests.App;
using LeanPipe.TestClient;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Hosting;

namespace LeanPipe.IntegrationTests;

public class TestApplicationFactory : WebApplicationFactory<Program>
{
    protected override IHost CreateHost(IHostBuilder builder)
    {
        builder.UseContentRoot(Directory.GetCurrentDirectory());
        return base.CreateHost(builder);
    }

    protected LeanPipeTestClient CreateLeanPipeTestClient(AuthenticatedAs authenticatedAs)
    {
        return new(
            new("http://localhost/leanpipe"),
            Program.LeanPipeTypes,
            hco =>
            {
                hco.HttpMessageHandlerFactory = _ => Server.CreateHandler();

                if (authenticatedAs != AuthenticatedAs.NotAuthenticated)
                {
                    hco.Headers.Add(
                        "Authorization",
                        new AuthenticationHeaderValue(
                            TestAuthenticationHandler.SchemeName,
                            TestAuthenticationHandler.SerializePrincipal(
                                authenticatedAs == AuthenticatedAs.UserWithoutRole
                                    ? AuthConfig.UserWithoutRole
                                    : AuthConfig.User
                            )
                        ).ToString()
                    );
                }
            }
        );
    }

    protected enum AuthenticatedAs
    {
        NotAuthenticated,
        UserWithoutRole,
        User,
    }
}
