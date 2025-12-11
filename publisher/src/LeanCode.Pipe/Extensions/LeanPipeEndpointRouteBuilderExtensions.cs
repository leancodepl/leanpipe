using System.Diagnostics.CodeAnalysis;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http.Connections;
using Microsoft.AspNetCore.Routing;

namespace LeanCode.Pipe;

public static class LeanPipeEndpointRouteBuilderExtensions
{
    /// <summary>
    /// Maps LeanPipe SignalR hub on the specified endpoint.
    /// </summary>
    public static IHubEndpointConventionBuilder MapLeanPipe(
        this IEndpointRouteBuilder endpoints,
        [StringSyntax("Route")] string pattern,
        Action<HttpConnectionDispatcherOptions>? configureOptions = null
    )
    {
        return endpoints.MapHub<LeanPipeSubscriber>(pattern, configureOptions);
    }
}
