using LeanCode.Contracts;
using LeanCode.Contracts.Security;
using LeanPipe.Example.Handlers.Authorizers;

namespace LeanPipe.Example.Contracts;

[AuthorizeWhenHasAnyOf("user")]
[AllowAuthorized]
public class Auction : ITopic, IProduceNotification<BidPlaced>, IProduceNotification<ItemSold>
{
    public string AuctionId { get; set; } = default!;
    public bool Authorized { get; set; }
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

    // just because we don't have auth yet here
    public string UserId { get; set; } = default!;
}

public class Buy : ICommand
{
    public string AuctionId { get; set; } = default!;
    public string UserId { get; set; } = default!;
}

public class AllowAuthorized : AuthorizeWhenAttribute
{
    public AllowAuthorized()
        : base(typeof(AllowAuthorizedAuthorizer)) { }
}
