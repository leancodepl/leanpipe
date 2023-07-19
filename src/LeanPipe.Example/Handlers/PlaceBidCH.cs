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

    public Task ExecuteAsync(HttpContext context, PlaceBid command)
    {
        return pipe.PublishAsync(
            new() { AuctionId = command.AuctionId },
            new BidPlaced { Amount = command.Amount, User = command.UserId },
            new(context)
        );
    }
}
