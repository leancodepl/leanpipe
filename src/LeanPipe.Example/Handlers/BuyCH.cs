using LeanCode.CQRS.Execution;
using LeanCode.LeanPipe;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers;

public class BuyCH : ICommandHandler<Buy>
{
    private readonly ILeanPipePublisher<Auction, ItemSold> pipe;

    public BuyCH(ILeanPipePublisher<Auction, ItemSold> pipe)
    {
        this.pipe = pipe;
    }

    public Task ExecuteAsync(HttpContext context, Buy command)
    {
        return pipe.SendAsync(
            new() { AuctionId = command.AuctionId },
            new() { Buyer = command.UserId }
        );
    }
}
