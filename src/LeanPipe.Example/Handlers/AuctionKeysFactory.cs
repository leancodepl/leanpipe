using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class AuctionKeysFactory : IKeysFactory<Auction, BidPlaced>, IKeysFactory<Auction, ItemSold>
{
    public Task<IEnumerable<string>> ToKeysAsync(Auction topic) =>
        Task.FromResult(new[] { $"{typeof(Auction)}:{topic.AuctionId}" }.AsEnumerable());

    // we should explain in docs that the default implementation of topic-based ToKeysAsync
    // is usually what you want everywhere
    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, BidPlaced notification) =>
        ToKeysAsync(topic);

    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, ItemSold notification) =>
        ToKeysAsync(topic);
}

// this is missing an implementation, but it will be cached at startup time
public class WrongKeysFactory : IKeysFactory<Auction, BidPlaced>
{
    public Task<IEnumerable<string>> ToKeysAsync(Auction topic) =>
        Task.FromResult(new[] { $"{typeof(Auction)}:{topic.AuctionId}" }.AsEnumerable());

    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, BidPlaced notification) =>
        ToKeysAsync(topic);
}
