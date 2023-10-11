using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.Funnel.Instance;

public static class ServiceCollectionExtensions
{
    public static void AddLeanPipeFunnel(this IServiceCollection services)
    {
        services
            .AddSignalR()
            .AddJsonProtocol(
                options => options.PayloadSerializerOptions.PropertyNamingPolicy = null
            );

        services.AddTransient(typeof(ISubscriptionExecutor), typeof(FunnelSubscriptionExecutor));
    }
}
