using LeanCode.CQRS.Execution;
using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class PlaceBidCH : ICommandHandler<PlaceBid>
{
    private readonly LeanPipePublisher<Auction, BidPlaced> pipe;

    public PlaceBidCH(LeanPipePublisher<Auction, BidPlaced> pipe)
    {
        this.pipe = pipe;
    }

    public Task ExecuteAsync(HttpContext context, PlaceBid command)
    {
        return pipe.SendAsync(
            new() { AuctionId = command.AuctionId },
            new() { Amount = command.Amount, User = command.UserId }
        );
    }
}
