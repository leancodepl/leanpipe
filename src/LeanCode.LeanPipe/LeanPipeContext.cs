using Microsoft.AspNetCore.Http;

namespace LeanCode.LeanPipe;

public class LeanPipeContext
{
    public LeanPipeContext(HttpContext context)
    {
        Context = context;
    }

    public HttpContext Context { get; private init; }
}
