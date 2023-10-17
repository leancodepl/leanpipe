using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.Pipe;

public interface ISubscribeContext
{
    Task AddToGroupsAsync(IEnumerable<string> groupKeys, CancellationToken ct);
    Task RemoveFromGroupsAsync(IEnumerable<string> groupKeys, CancellationToken ct);
}

public class LeanPipeSubscriber : Hub, ISubscribeContext
{
    private readonly ISubscriptionExecutor subscriptionExecutor;

    public LeanPipeSubscriber(ISubscriptionExecutor subscriptionExecutor)
    {
        this.subscriptionExecutor = subscriptionExecutor;
    }

    public async Task Subscribe(SubscriptionEnvelope envelope)
    {
        await ExecuteAsync(envelope, OperationType.Subscribe);
    }

    public async Task Unsubscribe(SubscriptionEnvelope envelope)
    {
        await ExecuteAsync(envelope, OperationType.Unsubscribe);
    }

    private async Task NotifyResultAsync(SubscriptionResult result)
    {
        await Clients.Caller.SendAsync("subscriptionResult", result, Context.ConnectionAborted);
    }

    private async Task ExecuteAsync(SubscriptionEnvelope envelope, OperationType type)
    {
        var httpContext =
            Context.GetHttpContext()
            ?? throw new InvalidOperationException(
                "Connection is not associated with an HTTP request."
            );

        var context = new LeanPipeContext(httpContext.User);

        var subscriptionStatus = await subscriptionExecutor.ExecuteAsync(
            envelope,
            type,
            this,
            context,
            Context.ConnectionAborted
        );

        await NotifyResultAsync(new(envelope.Id, subscriptionStatus, type));
    }

    Task ISubscribeContext.AddToGroupsAsync(IEnumerable<string> groupKeys, CancellationToken ct)
    {
        var tasks = groupKeys.Select(key => Groups.AddToGroupAsync(Context.ConnectionId, key, ct));

        return Task.WhenAll(tasks);
    }

    Task ISubscribeContext.RemoveFromGroupsAsync(
        IEnumerable<string> groupKeys,
        CancellationToken ct
    )
    {
        var tasks = groupKeys.Select(
            key => Groups.RemoveFromGroupAsync(Context.ConnectionId, key, ct)
        );

        return Task.WhenAll(tasks);
    }
}
