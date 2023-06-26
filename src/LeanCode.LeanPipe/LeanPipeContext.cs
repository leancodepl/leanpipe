using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

public interface ILeanPipeContext<TTopic, TNotification>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    Task SendAsync(TTopic topic, TNotification notification);
}

public class LeanPipeContext<TTopic, TNotification> : ILeanPipeContext<TTopic, TNotification>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    internal IHubContext<LeanPipe> HubContext { get; }
    internal IKeysFactory<TTopic> KeysFactory { get; }

    public LeanPipeContext(IHubContext<LeanPipe> hubContext, IKeysFactory<TTopic> keysFactory)
    {
        HubContext = hubContext;
        KeysFactory = keysFactory;
    }

    public virtual Task SendAsync(TTopic topic, TNotification notification)
    {
        var keys = KeysFactory.ToKeys(topic).ToList();
        var payload = NotificationEnvelope.Create(topic, notification);
        return HubContext.Clients.Groups(keys).SendAsync(nameof(TTopic), payload);
    }
}
