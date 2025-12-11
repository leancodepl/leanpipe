using LeanCode.Components;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;
using LeanCode.IntegrationTestHelpers;
using LeanCode.Logging.AspNetCore;
using LeanCode.Pipe;
using LeanCode.Pipe.Funnel.Instance;
using LeanCode.Pipe.Funnel.Publishing;
using LeanCode.Pipe.IntegrationTests.App;
using MassTransit;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

var appBuilder = WebApplication.CreateBuilder(args);
appBuilder.Host.ConfigureDefaultLogging(
    "IntegrationTests",
    [typeof(LeanCode.Pipe.IntegrationTests.App.Program).Assembly]
);

var services = appBuilder.Services;

if (!appBuilder.Configuration.GetValue<bool>("EnableFunnel"))
{
    services.AddLeanPipe(
        LeanCode.Pipe.IntegrationTests.App.Program.LeanPipeTypes,
        LeanCode.Pipe.IntegrationTests.App.Program.LeanPipeTypes
    );
}
else // We mimic Funnel behaviour on a single instance
{
    services.AddLeanPipeFunnel();
    services.AddFunnelledLeanPipe(
        LeanCode.Pipe.IntegrationTests.App.Program.LeanPipeTypes,
        LeanCode.Pipe.IntegrationTests.App.Program.LeanPipeTypes
    );

    services.AddMassTransitTestHarness(cfg =>
    {
        cfg.ConfigureLeanPipeFunnelConsumers();
        cfg.AddFunnelledLeanPipeConsumers(
            "TestApp",
            LeanCode.Pipe.IntegrationTests.App.Program.LeanPipeTypes.Assemblies
        );
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

        await ApiHandlers.PublishGreetingOrFarewellAsync(
            publisher,
            topic,
            notificationData,
            ctx.RequestAborted
        );
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

        await ApiHandlers.PublishProjectUpdatedOrDeletedAsync(
            publisher,
            topic,
            notificationData,
            ctx.RequestAborted
        );
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

        await ApiHandlers.PublishGreetingOrFarewellAsync(
            publisher,
            topic,
            notificationData,
            ctx.RequestAborted
        );
    }
);

app.Run();

namespace LeanCode.Pipe.IntegrationTests.App
{
    public sealed partial class Program
    {
        public static readonly TypesCatalog LeanPipeTypes = TypesCatalog.Of<SimpleTopic>();
    }
}
