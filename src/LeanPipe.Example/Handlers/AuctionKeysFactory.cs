using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class AuctionKeysFactory
    : BasicKeysFactory<Auction>,
        IKeysFactory<Auction, BidPlaced>,
        IKeysFactory<Auction, ItemSold>
{
    public override IEnumerable<string> ToKeys(Auction topic) =>
        new[] { $"{typeof(Auction)}:{topic.AuctionId}" }.AsEnumerable();

    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, BidPlaced notification) =>
        Task.FromResult(ToKeys(topic));

    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, ItemSold notification) =>
        Task.FromResult(ToKeys(topic));
}

// this is missing an implementation, but it will be cached at startup time
public class WrongKeysFactory : IKeysFactory<Auction, BidPlaced>
{
    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, LeanPipeSubscriber pipe) =>
        Task.FromResult(new[] { $"{typeof(Auction)}:{topic.AuctionId}" }.AsEnumerable());

    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, BidPlaced notification) =>
        Task.FromResult(new[] { "It's wrong anyway" }.AsEnumerable());
}
