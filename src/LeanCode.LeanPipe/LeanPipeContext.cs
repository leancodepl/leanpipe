using Microsoft.AspNetCore.Http;

namespace LeanCode.LeanPipe;

public class LeanPipeContext
{
    public LeanPipeContext(HttpContext context)
    {
        HttpContext = context;
    }

    public HttpContext HttpContext { get; private init; }
}
