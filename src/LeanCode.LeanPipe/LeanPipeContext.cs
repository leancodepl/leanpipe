using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

public interface ILeanPipeContext<TTopic, TNotification>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    Task Send(TTopic topic, TNotification notification);
}

public class LeanPipeContext<TTopic, TNotification>(IHubContext<LeanPipe> hubContext, IKeysFactory<TTopic> keysFactory) : ILeanPipeContext<TTopic, TNotification>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    internal IHubContext<LeanPipe> HubContext { get; } = hubContext;
    internal IKeysFactory<TTopic> KeysFactory { get; } = keysFactory;

    public virtual Task Send(TTopic topic, TNotification notification)
    {
        var keys = KeysFactory.ToKeys(topic).ToList();
        var payload = new Envelope(topic, notification);
        return HubContext.Clients.Groups(keys).SendAsync(nameof(TTopic), payload);
    }
}
