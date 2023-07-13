namespace LeanPipe.Example.Domain;

public class Fan
{
    public string Id { get; init; } = default!;
    public List<string> WatchedGames { get; } = new();
    public List<string> WatchedPlayers { get; } = new();
}

public class Game
{
    public string Id { get; init; } = default!;
    public List<string> Players { get; } = new();
}
