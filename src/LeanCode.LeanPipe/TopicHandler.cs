using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

public interface ITopicHandler<TTopic, TNotification>
    where TTopic : ITopic, IProduceNotification<TNotification>
{
    IKeysFactory<TTopic> KeysFactory { get; }
    // honestly I think we should rather have hub context hidden in the executor
    // I'll move it in the next iteration of this draft
    IHubContext<LeanPipe> HubContext { get; }

    // and then this should rather return whatever executor should send
    Task Send(TTopic topic, TNotification notification);
}

public abstract class TopicHandler<TTopic, TNotification>(IHubContext<LeanPipe> hubContext, IKeysFactory<TTopic> keysFactory) : ITopicHandler<TTopic, TNotification>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    public IHubContext<LeanPipe> HubContext { get; } = hubContext;
    public IKeysFactory<TTopic> KeysFactory { get; } = keysFactory;

    public virtual Task Send(TTopic topic, TNotification notification)
    {
        var keys = KeysFactory.ToKeys(topic).ToList();
        var payload = new Envelope(topic, notification);
        return HubContext.Clients.Groups(keys).SendAsync(nameof(TTopic), payload);
    }
}
