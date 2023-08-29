using Microsoft.AspNetCore.Http;

namespace LeanCode.LeanPipe;

public class LeanPipeContext
{
    public LeanPipeContext(HttpContext httpContext)
    {
        HttpContext = httpContext;
    }

    public HttpContext HttpContext { get; private init; }
}
