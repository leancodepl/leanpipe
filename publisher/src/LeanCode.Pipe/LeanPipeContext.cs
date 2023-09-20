using Microsoft.AspNetCore.Http;

namespace LeanCode.Pipe;

public class LeanPipeContext
{
    public LeanPipeContext(HttpContext httpContext)
    {
        HttpContext = httpContext;
    }

    public HttpContext HttpContext { get; private init; }
}
