using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.Funnel.Instance;

public static class ServiceCollectionExtensions
{
    /// <summary>
    /// Adds SignalR and other services required for the Funnel.
    /// </summary>
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
