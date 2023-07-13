using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

public class LeanPipePublisher<TTopic, TNotification>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    internal IHubContext<LeanPipeSubscriber> HubContext { get; }
    internal IKeysFactory<TTopic, TNotification> KeysFactory { get; }

    public LeanPipePublisher(
        IHubContext<LeanPipeSubscriber> hubContext,
        IKeysFactory<TTopic, TNotification> keysFactory
    )
    {
        HubContext = hubContext;
        KeysFactory = keysFactory;
    }

    public virtual async Task SendAsync(TTopic topic, TNotification notification)
    {
        var keys = await KeysFactory.ToKeysAsync(topic, notification);
        var payload = NotificationEnvelope.Create(topic, notification);
        await HubContext.Clients.Groups(keys).SendAsync("notify", payload);
    }
}
