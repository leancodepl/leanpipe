using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;
using LeanPipe.Example.DataAccess;
using Microsoft.EntityFrameworkCore;

namespace LeanPipe.Example.Handlers;

public class GamesTopicController
    : ITopicController<Games, GameFinished>,
        ITopicController<Games, GameCancelled>
{
    private readonly GamesContext dbContext;

    public GamesTopicController(GamesContext dbContext)
    {
        this.dbContext = dbContext;
    }

    public async Task<IEnumerable<string>> ToKeysAsync(Games topic, LeanPipeContext context)
    {
        var fanId = new Guid().ToString();
        var fan = await dbContext.Fans.AsQueryable().FirstAsync(f => f.Id == fanId);
        var keys = fan.WatchedGames.Select(g => $"game:{g}");
        return keys;
    }

    public Task<IEnumerable<string>> ToKeysAsync(
        Games topic,
        GameFinished notification,
        LeanPipeContext context
    ) =>
        Task.FromResult(
            new[] { $"game:{notification.GameId}", $"player:{notification.Winner}" }.AsEnumerable()
        );

    public Task<IEnumerable<string>> ToKeysAsync(
        Games topic,
        GameCancelled notification,
        LeanPipeContext context
    ) => Task.FromResult(new[] { $"game:{notification.GameId}" }.AsEnumerable());
}
