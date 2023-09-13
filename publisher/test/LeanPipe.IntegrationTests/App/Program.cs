using LeanCode.Components;
using LeanCode.CQRS.Security;
using LeanCode.IntegrationTestHelpers;
using LeanPipe;
using LeanPipe.IntegrationTests.App;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;

var appBuilder = WebApplication.CreateBuilder(args);
var services = appBuilder.Services;

services.AddLeanPipe(LeanPipeTypes, LeanPipeTypes);

services.AddSingleton<IRoleRegistration, AppRoles>();

services.AddRouting();

services.AddAuthentication(TestAuthenticationHandler.SchemeName).AddTestAuthenticationHandler();

using var app = appBuilder.Build();

app.UseRouting();
app.UseAuthentication();
app.UseEndpoints(e =>
{
    e.MapLeanPipe("/leanpipe");

    e.Map(
        "/publish_unauthorized",
        async (
            HttpContext ctx,
            NotificationDataDTO notificationData,
            LeanPipePublisher<UnauthorizedTopic> publisher
        ) =>
        {
            var topic = new UnauthorizedTopic { TopicId = notificationData.TopicId };

            await ApiHandlers.PublishGreetingOrFarewell(
                publisher,
                topic,
                notificationData,
                ctx.RequestAborted
            );
        }
    );

    e.Map(
        "/publish_authorized",
        async (
            HttpContext ctx,
            NotificationDataDTO notificationData,
            LeanPipePublisher<AuthorizedTopic> publisher
        ) =>
        {
            var topic = new AuthorizedTopic { TopicId = notificationData.TopicId };

            await ApiHandlers.PublishGreetingOrFarewell(
                publisher,
                topic,
                notificationData,
                ctx.RequestAborted
            );
        }
    );
});

app.Run();

public partial class Program
{
    public static readonly TypesCatalog LeanPipeTypes = TypesCatalog.Of<UnauthorizedTopic>();
}
