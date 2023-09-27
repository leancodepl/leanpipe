using Microsoft.AspNetCore.Http;

namespace LeanCode.Pipe;

/// <summary>
/// Context that is included in all LeanPipe subscriptions.
/// </summary>
public class LeanPipeContext
{
    public LeanPipeContext(HttpContext httpContext)
    {
        HttpContext = httpContext;
    }

    public HttpContext HttpContext { get; private init; }
}
