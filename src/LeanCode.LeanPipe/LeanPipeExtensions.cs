using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http.Connections;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanCode.LeanPipe.Extensions;

public static class LeanPipeExtensions
{
    public static IServiceCollection AddLeanPipe(this IServiceCollection services)
    {
        services.AddSignalR();
        services.TryAdd(ServiceDescriptor.Transient(typeof(IKeysFactory<>), typeof(DefaultKeysFactory<>)));
        services.TryAdd(ServiceDescriptor.Transient(typeof(ISubscriptionHandler<>), typeof(KeyedSubscriptionHandler<>)));
        services.TryAdd(ServiceDescriptor.Transient(typeof(ILeanPipeContext<,>), typeof(LeanPipeContext<,>)));
        return services;
    }

    public static IHubEndpointConventionBuilder MapLeanPipe(this IEndpointRouteBuilder endpoints, string pattern)
    {
        return endpoints.MapHub<LeanPipe>(pattern);
    }
    public static IHubEndpointConventionBuilder MapLeanPipe(this IEndpointRouteBuilder endpoints, string pattern, Action<HttpConnectionDispatcherOptions>? configureOptions)
    {
        return endpoints.MapHub<LeanPipe>(pattern, configureOptions);
    }
}