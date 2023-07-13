using LeanCode.Contracts;

namespace LeanPipe.Example.Contracts;

public class Games
    : ITopic,
        IProduceNotification<GameFinished>,
        IProduceNotification<GameCancelled> { }

public class GameFinished
{
    public string GameId { get; set; } = default!;
    public string Winner { get; set; } = default!;
}

public class GameCancelled
{
    public string GameId { get; set; } = default!;
}
