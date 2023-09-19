using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http.Connections;
using Microsoft.AspNetCore.Routing;

namespace LeanCode.Pipe;

public static class PipeEndpointRouteBuilderExtensions
{
    public static IHubEndpointConventionBuilder MapPipe(
        this IEndpointRouteBuilder endpoints,
        string pattern
    )
    {
        return endpoints.MapHub<PipeSubscriber>(pattern);
    }

    public static IHubEndpointConventionBuilder MapPipe(
        this IEndpointRouteBuilder endpoints,
        string pattern,
        Action<HttpConnectionDispatcherOptions>? configureOptions
    )
    {
        return endpoints.MapHub<PipeSubscriber>(pattern, configureOptions);
    }
}
