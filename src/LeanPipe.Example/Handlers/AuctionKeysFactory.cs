using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class AuctionKeysFactory : IKeysFactory<Auction, BidPlaced>, IKeysFactory<Auction, ItemSold>
{
    public Task<IEnumerable<string>> ToKeysAsync(Auction topic)
    {
        return Task.FromResult(new[] { $"{typeof(Auction)}:{topic.AuctionId}" }.AsEnumerable());
    }

    // we should explain in docs that the default implementation of topic-based ToKeysAsync
    // is usually what you want everywhere
    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, BidPlaced notification) =>
        ToKeysAsync(topic);

    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, ItemSold notification) =>
        ToKeysAsync(topic);
}
