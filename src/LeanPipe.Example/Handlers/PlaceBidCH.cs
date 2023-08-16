using LeanCode.CQRS.Execution;
using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class PlaceBidCH : ICommandHandler<PlaceBid>
{
    private readonly LeanPipePublisher<Auction> pipe;

    public PlaceBidCH(LeanPipePublisher<Auction> pipe)
    {
        this.pipe = pipe;
    }

    public async Task ExecuteAsync(HttpContext context, PlaceBid command)
    {
        await pipe.PublishAsync(
            new() { AuctionId = command.AuctionId, Authorized = true },
            new BidPlaced { Amount = command.Amount, User = command.UserId },
            new(context)
        );
        await pipe.PublishAsync(
            new() { AuctionId = command.AuctionId, Authorized = false },
            new BidPlaced { Amount = command.Amount, User = command.UserId },
            new(context)
        );
    }
}
