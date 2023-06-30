using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;
using LeanPipe.Example.DataAccess;

namespace LeanPipe.Example.Handlers;

public class GamesKeysFactory
    : IKeysFactory<Games, GameFinished>,
        IKeysFactory<Games, GameCancelled>
{
    private readonly GamesContext dbContext;

    public GamesKeysFactory(GamesContext dbContext)
    {
        this.dbContext = dbContext;
    }

    public Task<IEnumerable<string>> ToKeysAsync(Games topic, LeanPipeSubscriber pipe)
    {
        var fanId = pipe.Context.UserIdentifier;
        var fan = dbContext.Fans.First(f => f.Id == fanId);
        var keys = fan.WatchedGames.Select(g => $"game:{g}");
        return Task.FromResult(keys);
    }

    public Task<IEnumerable<string>> ToKeysAsync(Games topic, GameFinished notification) =>
        Task.FromResult(
            new[] { $"game:{notification.GameId}", $"player:{notification.Winner}" }.AsEnumerable()
        );

    public Task<IEnumerable<string>> ToKeysAsync(Games topic, GameCancelled notification) =>
        Task.FromResult(new[] { $"game:{notification.GameId}" }.AsEnumerable());
}
