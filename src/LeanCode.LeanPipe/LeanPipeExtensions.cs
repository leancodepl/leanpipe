using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http.Connections;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanCode.LeanPipe.Extensions;

public static class LeanPipeExtensions
{
    public static IServiceCollection AddLeanPipe(this IServiceCollection services) =>
        services.AddLeanPipe(typeof(DefaultEnvelopeDeserializer));

    public static IServiceCollection AddLeanPipe(
        this IServiceCollection services,
        Type envelopeDeserializer
    )
    {
        services.AddSignalR();
        services.TryAddTransient(typeof(IEnvelopeDeserializer), envelopeDeserializer);
        services.AddTransient(typeof(ISubscriptionHandler<>), typeof(KeyedSubscriptionHandler<>));
        services.AddTransient(typeof(ILeanPipePublisher<,>), typeof(LeanPipePublisher<,>));
        return services;
    }

    public static IHubEndpointConventionBuilder MapLeanPipe(
        this IEndpointRouteBuilder endpoints,
        string pattern
    )
    {
        return endpoints.MapHub<LeanPipeSubscriber>(pattern);
    }

    public static IHubEndpointConventionBuilder MapLeanPipe(
        this IEndpointRouteBuilder endpoints,
        string pattern,
        Action<HttpConnectionDispatcherOptions>? configureOptions
    )
    {
        return endpoints.MapHub<LeanPipeSubscriber>(pattern, configureOptions);
    }
}
