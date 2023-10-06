using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.Funnel.Instance;

public static class FunnelServiceCollectionExtensions
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
