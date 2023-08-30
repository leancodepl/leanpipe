using Microsoft.AspNetCore.Http;

namespace LeanPipe;

public class LeanPipeContext
{
    public LeanPipeContext(HttpContext httpContext)
    {
        HttpContext = httpContext;
    }

    public HttpContext HttpContext { get; private init; }
}
