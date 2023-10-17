using System.Security.Claims;
using System.Text.Json.Serialization;
using LeanCode.Pipe.Funnel;

namespace LeanCode.Pipe;

/// <summary>
/// Context that is included in all LeanPipe subscriptions.
/// </summary>
public class LeanPipeContext
{
    [JsonConverter(typeof(ClaimsPrincipalJsonConverter))]
    public ClaimsPrincipal User { get; private init; }

    public LeanPipeContext(ClaimsPrincipal user)
    {
        User = user;
    }
}
