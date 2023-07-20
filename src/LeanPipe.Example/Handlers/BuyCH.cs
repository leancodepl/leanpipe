using LeanCode.CQRS.Execution;
using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class BuyCH : ICommandHandler<Buy>
{
    private readonly LeanPipePublisher<Auction> pipe;

    public BuyCH(LeanPipePublisher<Auction> pipe)
    {
        this.pipe = pipe;
    }

    public Task ExecuteAsync(HttpContext context, Buy command)
    {
        return pipe.PublishAsync(
            new() { AuctionId = command.AuctionId },
            new ItemSold { Buyer = command.UserId },
            new(context)
        );
    }
}
