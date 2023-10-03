using System.Security.Claims;

namespace LeanCode.Pipe;

/// <summary>
/// Context that is included in all LeanPipe subscriptions.
/// </summary>
public class LeanPipeContext
{
    public ClaimsPrincipal User { get; private init; }

    public LeanPipeContext(ClaimsPrincipal user)
    {
        User = user;
    }
}
