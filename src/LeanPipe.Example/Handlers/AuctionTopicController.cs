using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class AuctionTopicController
    : BasicTopicController<Auction>,
        ITopicController<Auction, BidPlaced>,
        ITopicController<Auction, ItemSold>
{
    public override IEnumerable<string> ToKeys(Auction topic) =>
        new[] { $"{typeof(Auction)}:{topic.AuctionId}:{topic.Authorized}" }.AsEnumerable();

    public Task<IEnumerable<string>> ToKeysAsync(
        Auction topic,
        BidPlaced notification,
        LeanPipeContext context
    ) => Task.FromResult(ToKeys(topic));

    public Task<IEnumerable<string>> ToKeysAsync(
        Auction topic,
        ItemSold notification,
        LeanPipeContext context
    ) => Task.FromResult(ToKeys(topic));
}

// this is missing an implementation, but it will be cached at startup time
public class WrongTopicController : ITopicController<Auction, BidPlaced>
{
    public Task<IEnumerable<string>> ToKeysAsync(Auction topic, LeanPipeContext context) =>
        Task.FromResult(new[] { $"{typeof(Auction)}:{topic.AuctionId}" }.AsEnumerable());

    public Task<IEnumerable<string>> ToKeysAsync(
        Auction topic,
        BidPlaced notification,
        LeanPipeContext context
    ) => Task.FromResult(new[] { "It's wrong anyway" }.AsEnumerable());
}
