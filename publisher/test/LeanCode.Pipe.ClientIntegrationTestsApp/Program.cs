using LeanCode.Components;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;
using LeanCode.Logging.AspNetCore;
using LeanCode.Pipe;
using LeanCode.Pipe.ClientIntegrationTestsApp;
using LeanCode.Pipe.ClientIntegrationTestsApp.Contracts;
using LeanCode.Pipe.Funnel.Instance;
using LeanCode.Pipe.Funnel.Publishing;
using MassTransit;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http.Connections;

var appBuilder = WebApplication.CreateBuilder(args);
var hostBuilder = appBuilder.Host;

hostBuilder.ConfigureDefaultLogging("TestApp", new[] { typeof(Program).Assembly });

var services = appBuilder.Services;
var leanPipeTypes = TypesCatalog.Of<Topic>();
var leanPipeHandlers = TypesCatalog.Of<TopicKeys>();

var enableFunnel = appBuilder.Configuration.GetValue<bool>("EnableFunnel");
if (!enableFunnel)
{
    services.AddLeanPipe(leanPipeTypes, leanPipeHandlers);
}
else // We mimic Funnel behaviour on a single instance
{
    services.AddLeanPipeFunnel();
    services.AddFunnelledLeanPipe(leanPipeTypes, leanPipeHandlers);

    services.AddOptions<MassTransitHostOptions>().Configure(opts => opts.WaitUntilStarted = true);
    services.AddMassTransit(cfg =>
    {
        cfg.ConfigureLeanPipeFunnelConsumers();
        cfg.AddFunnelledLeanPipeConsumers("ClientIntegrationTestsApp", leanPipeTypes.Assemblies);

        cfg.UsingInMemory(
            (ctx, cfg) =>
            {
                cfg.ConfigureEndpoints(ctx);
            }
        );
    });
}

services.AddSingleton<IRoleRegistration, AppRoles>();
services.AddSingleton<RoleRegistry>();
services.AddScoped<IHasPermissions, DefaultPermissionAuthorizer>();

services.AddRouting();

services
    .AddAuthentication(TestAuthenticationHandler.SchemeName)
    .AddScheme<AuthenticationSchemeOptions, TestAuthenticationHandler>(
        TestAuthenticationHandler.SchemeName,
        null
    );

services.AddHealthChecks();

using var app = appBuilder.Build();

app.UseRouting();
app.UseAuthentication();

app.MapHealthChecks("/health/live");
app.MapHealthChecks("/health/ready", new() { Predicate = check => check.Tags.Contains("ready") });

app.MapLeanPipe(
    "/leanpipe",
    opts =>
    {
        if (enableFunnel)
        {
            opts.Transports = HttpTransportType.WebSockets;
        }
    }
);

app.MapPost(
    "/publish",
    async (HttpContext ctx, Topic topic, ILeanPipePublisher<Topic> publisher) =>
        await publisher.PublishAsync(
            topic,
            new NotificationDTO { Greeting = $"Hello from topic {topic.TopicId}" },
            ctx.RequestAborted
        )
);

app.Run();
