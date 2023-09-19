using Microsoft.AspNetCore.Http;

namespace LeanCode.Pipe;

public class PipeContext
{
    public PipeContext(HttpContext httpContext)
    {
        HttpContext = httpContext;
    }

    public HttpContext HttpContext { get; private init; }
}
