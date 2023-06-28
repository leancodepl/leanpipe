using LeanCode.Contracts;

namespace LeanPipe.Example.Contracts;

public class Auction : ITopic, IProduceNotification<BidPlaced>, IProduceNotification<ItemSold>
{
    public string AuctionId { get; set; } = default!;
}

public class BidPlaced
{
    public int Amount { get; set; }
    public string User { get; set; } = default!;
}

public class ItemSold
{
    public string Buyer { get; set; } = default!;
}

public class PlaceBid : ICommand
{
    public string AuctionId { get; set; } = default!;
    public int Amount { get; set; }
}

public class Buy : ICommand
{
    public string AuctionId { get; set; } = default!;
    public string UserId { get; set; } = default!;
}
