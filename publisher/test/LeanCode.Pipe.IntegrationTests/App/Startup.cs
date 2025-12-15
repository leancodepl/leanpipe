using LeanCode.Components;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;
using LeanCode.IntegrationTestHelpers;
using LeanCode.Pipe.Funnel.Instance;
using LeanCode.Pipe.Funnel.Publishing;
using MassTransit;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.IntegrationTests.App;

// Using traditional Startup class instead of minimal API because WebApplicationFactory's
// HostFactoryResolver conflicts with xUnit v3's Microsoft Testing Platform generated entry point.
// With minimal APIs, the tests hang or fail with "The entry point exited without ever building an IHost".
public class Startup(IConfiguration configuration)
{
    public static readonly TypesCatalog LeanPipeTypes = TypesCatalog.Of<SimpleTopic>();

    public void ConfigureServices(IServiceCollection services)
    {
        if (!configuration.GetValue<bool>("EnableFunnel"))
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

        services
            .AddAuthentication(TestAuthenticationHandler.SchemeName)
            .AddTestAuthenticationHandler();
    }

    public static void Configure(IApplicationBuilder app)
    {
        app.UseRouting();
        app.UseAuthentication();

        app.UseEndpoints(endpoints =>
        {
            endpoints.MapLeanPipe("/leanpipe");

            endpoints.MapPost(
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

            endpoints.MapPost(
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

            endpoints.MapPost(
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
        });
    }
}
