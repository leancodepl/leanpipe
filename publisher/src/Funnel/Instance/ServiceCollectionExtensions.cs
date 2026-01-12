using LeanCode.Serialization;
using Microsoft.AspNetCore.SignalR;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.Funnel.Instance;

public static class ServiceCollectionExtensions
{
    /// <summary>
    /// Adds SignalR and other services required for the Funnel.
    /// </summary>
    public static IServiceCollection AddLeanPipeFunnel(
        this IServiceCollection services,
        FunnelConfiguration? config = null,
        Action<HubOptions<LeanPipeSubscriber>>? configureLeanPipeHub = null,
        Action<JsonHubProtocolOptions>? overrideJsonHubProtocolOptions = null
    )
    {
        var signalRBuilder = services
            .AddSignalR()
            .AddJsonProtocol(
                overrideJsonHubProtocolOptions
                    ?? (options => options.PayloadSerializerOptions.ConfigureForCQRS())
            );

        if (configureLeanPipeHub is not null)
        {
            signalRBuilder.AddHubOptions(configureLeanPipeHub);
        }

        services.AddMemoryCache();

        services.AddSingleton(config ?? FunnelConfiguration.Default);
        services.AddTransient<ISubscriptionExecutor, FunnelSubscriptionExecutor>();

        return services;
    }
}
