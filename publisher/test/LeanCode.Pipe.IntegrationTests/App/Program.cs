using LeanCode.Components;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;
using LeanCode.IntegrationTestHelpers;
using LeanCode.Pipe;
using LeanCode.Pipe.IntegrationTests.App;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

var appBuilder = WebApplication.CreateBuilder(args);
var services = appBuilder.Services;

services.AddPipe(
    LeanCode.Pipe.IntegrationTests.App.Program.PipeTypes,
    LeanCode.Pipe.IntegrationTests.App.Program.PipeTypes
);

services.AddSingleton<IRoleRegistration, AppRoles>();
services.AddSingleton<RoleRegistry>();
services.AddScoped<IHasPermissions, DefaultPermissionAuthorizer>();

services.AddRouting();

services.AddAuthentication(TestAuthenticationHandler.SchemeName).AddTestAuthenticationHandler();

using var app = appBuilder.Build();

app.UseRouting();
app.UseAuthentication();

app.MapPipe("/pipe");

app.MapPost(
    "/publish_basic",
    async (
        HttpContext ctx,
        NotificationDataDTO notificationData,
        PipePublisher<BasicTopic> publisher
    ) =>
    {
        var topic = new BasicTopic { TopicId = notificationData.TopicId };

        await ApiHandlers.PublishGreetingOrFarewellAsync(
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
        PipePublisher<AuthorizedTopic> publisher
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
    public partial class Program
    {
        public static readonly TypesCatalog PipeTypes = TypesCatalog.Of<BasicTopic>();
    }
}
