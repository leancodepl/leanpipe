using LeanCode.Components;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;
using LeanCode.IntegrationTestHelpers;
using LeanCode.Pipe;
using LeanCode.Pipe.Funnel.FunnelledService;
using LeanCode.Pipe.Funnel.Instance;
using LeanCode.Pipe.IntegrationTests.App;
using MassTransit;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Connections;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Logging;

var appBuilder = WebApplication.CreateBuilder(args);
appBuilder.Logging.SetMinimumLevel(LogLevel.Debug);

var services = appBuilder.Services;

if (!appBuilder.Configuration.GetValue<bool>("EnableFunnel"))
{
    services.AddLeanPipe(LeanPipeTypes, LeanPipeTypes);
}
else // We mimic Funnel behaviour on a single instance
{
    services.AddLeanPipeFunnel();
    services.AddFunnelledLeanPipe(LeanPipeTypes, LeanPipeTypes);

    services.AddMassTransitTestHarness(cfg =>
    {
        cfg.ConfigureLeanPipeFunnelConsumers();
        cfg.AddFunnelledLeanPipeConsumers("TestApp", LeanPipeTypes.Assemblies);
    });
}

services.AddSingleton<IRoleRegistration, AppRoles>();
services.AddSingleton<RoleRegistry>();
services.AddScoped<IHasPermissions, DefaultPermissionAuthorizer>();

services.AddRouting();

services.AddAuthentication(TestAuthenticationHandler.SchemeName).AddTestAuthenticationHandler();

using var app = appBuilder.Build();

app.UseRouting();
app.UseAuthentication();

app.MapLeanPipe("/leanpipe");

app.MapPost(
    "/publish_simple",
    async (
        HttpContext ctx,
        NotificationDataDTO notificationData,
        ILeanPipePublisher<SimpleTopic> publisher
    ) =>
    {
        var topic = new SimpleTopic { TopicId = notificationData.TopicId };

        await ApiHandlers
            .PublishGreetingOrFarewellAsync(publisher, topic, notificationData, ctx.RequestAborted)
            .ConfigureAwait(false);
    }
);

app.MapPost(
    "/publish_dynamic",
    async (
        HttpContext ctx,
        ProjectNotificationDataDTO notificationData,
        ILeanPipePublisher<MyFavouriteProjectsTopic> publisher
    ) =>
    {
        var topic = new MyFavouriteProjectsTopic();

        await ApiHandlers
            .PublishProjectUpdatedOrDeletedAsync(
                publisher,
                topic,
                notificationData,
                ctx.RequestAborted
            )
            .ConfigureAwait(false);
    }
);

app.MapPost(
    "/publish_authorized",
    async (
        HttpContext ctx,
        NotificationDataDTO notificationData,
        ILeanPipePublisher<AuthorizedTopic> publisher
    ) =>
    {
        var topic = new AuthorizedTopic { TopicId = notificationData.TopicId };

        await ApiHandlers
            .PublishGreetingOrFarewellAsync(publisher, topic, notificationData, ctx.RequestAborted)
            .ConfigureAwait(false);
    }
);

app.Run();

public partial class Program
{
    public static readonly TypesCatalog LeanPipeTypes = TypesCatalog.Of<SimpleTopic>();
}
