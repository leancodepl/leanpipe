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

    public async Task ExecuteAsync(HttpContext context, Buy command)
    {
        await pipe.PublishAsync(
            new() { AuctionId = command.AuctionId, Authorized = true },
            new ItemSold { Buyer = command.UserId },
            new(context)
        );
        await pipe.PublishAsync(
            new() { AuctionId = command.AuctionId, Authorized = false },
            new ItemSold { Buyer = command.UserId },
            new(context)
        );
    }
}
