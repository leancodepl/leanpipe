using System.Net.Http.Headers;
using LeanCode.IntegrationTestHelpers;
using LeanCode.Logging.AspNetCore;
using LeanCode.Pipe.IntegrationTests.App;
using LeanCode.Pipe.TestClient;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc.Testing;
using Microsoft.Extensions.Hosting;

namespace LeanCode.Pipe.IntegrationTests;

public class TestApplicationFactory : WebApplicationFactory<Startup>
{
    protected override IHostBuilder CreateHostBuilder()
    {
        return Host.CreateDefaultBuilder()
            .ConfigureDefaultLogging("IntegrationTests", [typeof(Startup).Assembly])
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<Startup>();
            });
    }

    protected override IHost CreateHost(IHostBuilder builder)
    {
        builder.UseContentRoot(Directory.GetCurrentDirectory());
        return base.CreateHost(builder);
    }

    protected LeanPipeTestClient CreateLeanPipeTestClient(AuthenticatedAs authenticatedAs)
    {
        return new(
            new("http://localhost/leanpipe"),
            Startup.LeanPipeTypes,
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
