using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class AuctionKeysFactory : IKeysFactory<Auction>
{
    public IEnumerable<string> ToKeys(Auction topic)
    {
        yield return $"{typeof(Auction)}:{topic.AuctionId}";
    }
}
