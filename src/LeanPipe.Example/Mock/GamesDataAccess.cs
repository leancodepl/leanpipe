using LeanPipe.Example.Domain;

namespace LeanPipe.Example.DataAccess;

public class GamesContext
{
    public List<Game> Games = new();
    public List<Fan> Fans = new();
}
