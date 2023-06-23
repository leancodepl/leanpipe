using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

// a bit redundant, but we need to pass a specific type Hub type to the IHubContext
// I had problems with making it work with a more generic solution previously
public interface ITopicHandler<TPipe, TTopic, TNotification>
    where TPipe : LeanPipe<TTopic>
    where TTopic : ITopic, IProduceNotification<TNotification>
{
    IKeysFactory<TTopic> KeysFactory { get; }
    // honestly I think we should rather have hub context hidden in the executor
    // I'll move it in the next iteration of this draft
    IHubContext<TPipe> HubContext { get; }

    // and then this should rather return whatever executor should send
    Task Send(TTopic topic, TNotification notification);
}

public abstract class TopicHandler<TPipe, TTopic, TNotification>(IHubContext<TPipe> hubContext, IKeysFactory<TTopic> keysFactory) : ITopicHandler<TPipe, TTopic, TNotification>
    where TPipe : LeanPipe<TTopic>
    where TTopic : ITopic, IProduceNotification<TNotification>
{
    public IHubContext<TPipe> HubContext { get; } = hubContext;
    public IKeysFactory<TTopic> KeysFactory { get; } = keysFactory;

    public virtual Task Send(TTopic topic, TNotification notification)
    {
        var keys = KeysFactory.ToKeys(topic).ToList();
        var payload = new Envelope(topic, notification);
        return HubContext.Clients.Groups(keys).SendAsync(nameof(TTopic), payload);
    }
}
