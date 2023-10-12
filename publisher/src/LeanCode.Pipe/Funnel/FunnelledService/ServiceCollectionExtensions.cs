using LeanCode.Components;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.Funnel.FunnelledService;

public static class ServiceCollectionExtensions
{
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
