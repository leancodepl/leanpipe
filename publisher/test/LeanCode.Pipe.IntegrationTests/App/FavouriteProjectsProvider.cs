using System.Diagnostics.CodeAnalysis;
using System.Security.Claims;

namespace LeanCode.Pipe.IntegrationTests.App;

public class FavouriteProjectsProvider
{
    public static readonly Guid FavouriteProjectId1 = Guid.Parse(
        "5c8679c7-92b3-4ad8-94e5-2f90951b24ca"
    );

    public static readonly Guid FavouriteProjectId2 = Guid.Parse(
        "1940c367-bd63-4344-b7c6-2bade4f14a1d"
    );

    [SuppressMessage("Performance", "CA1822:Mark members as static")]
    public Task<List<Guid>> GetUsersFavouriteProjectsAsync(ClaimsPrincipal user) =>
        Task.FromResult(new List<Guid> { FavouriteProjectId1, FavouriteProjectId2 });
}
