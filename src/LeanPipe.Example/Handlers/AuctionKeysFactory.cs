using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class AuctionKeysFactory : IKeysFactory<Auction, BidPlaced>, IKeysFactory<Auction, ItemSold>
{
    public Task<IEnumerable<string>> ToKeysAsync(Auction topic)
    {
        return Task.FromResult(new[] { $"{typeof(Auction)}:{topic.AuctionId}" }.AsEnumerable());
    }
}
