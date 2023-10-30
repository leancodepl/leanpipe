using LeanCode.Components;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;
using LeanCode.Pipe;
using LeanCode.Pipe.ClientIntegrationTestsApp;
using LeanCode.Pipe.Funnel.FunnelledService;
using LeanCode.Pipe.Funnel.Instance;
using MassTransit;
using Microsoft.AspNetCore.Authentication;

var appBuilder = WebApplication.CreateBuilder(args);
appBuilder.Logging.SetMinimumLevel(LogLevel.Debug);

var services = appBuilder.Services;
var leanPipeTypes = TypesCatalog.Of<Topic>();

if (!appBuilder.Configuration.GetValue<bool>("EnableFunnel"))
{
    services.AddLeanPipe(leanPipeTypes, leanPipeTypes);
}
else // We mimic Funnel behaviour on a single instance
{
    services.AddLeanPipeFunnel();
    services.AddFunnelledLeanPipe(leanPipeTypes, leanPipeTypes);

    services.AddMassTransitTestHarness(cfg =>
    {
        cfg.ConfigureLeanPipeFunnelConsumers();
        cfg.AddFunnelledLeanPipeConsumers("ClientIntegrationTestsApp", leanPipeTypes.Assemblies);
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

using var app = appBuilder.Build();

app.UseRouting();
app.UseAuthentication();

app.MapLeanPipe("/leanpipe");

app.MapPost(
    "/publish",
    async (HttpContext ctx, Topic topic, ILeanPipePublisher<Topic> publisher) =>
        await publisher.PublishAsync(
            topic,
            new NotificationDTO { Greeting = $"Hello from topic {topic.TopicId}" },
            ctx.RequestAborted
        )
);
