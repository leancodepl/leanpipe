using LeanCode.Components;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.Funnel.FunnelledService;

public static class ServiceCollectionExtensions
{
    /// <summary>
    /// Adds all classes required for LeanPipe with Funnel to function to DI.
    /// </summary>
    /// <returns>Service builder allowing for overriding default LeanPipe implementations
    /// and further configuration.</returns>
    /// <remarks>SignalR is not registered because it's not needed in this variant.</remarks>
    public static LeanPipeServicesBuilder AddFunnelledLeanPipe(
        this IServiceCollection services,
        TypesCatalog topics,
        TypesCatalog handlers
    )
    {
        services.AddTransient<LeanPipeSecurity>();
        services.AddTransient<SubscriptionExecutor>();
        services.AddTransient(typeof(ISubscriptionHandler<>), typeof(KeyedSubscriptionHandler<>));
        services.AddTransient(typeof(ILeanPipePublisher<>), typeof(FunnelledLeanPipePublisher<>));
        services.AddTransient<SubscriptionHandlerResolver>();

        return new LeanPipeServicesBuilder(services, topics).AddHandlers(handlers);
    }
}
