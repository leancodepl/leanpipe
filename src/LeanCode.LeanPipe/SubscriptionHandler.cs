using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public interface ISubscriptionHandler<in TTopic>
    where TTopic : ITopic
{
    Task OnSubscribed(TTopic topic, LeanPipe pipe);
    Task OnUnsubscribed(TTopic topic, LeanPipe pipe);
}

public class KeyedSubscriptionHandler<TTopic> : ISubscriptionHandler<TTopic>
    where TTopic : ITopic
{
    private readonly IKeysFactory<TTopic> keysFactory;

    public KeyedSubscriptionHandler(IKeysFactory<TTopic> keysFactory)
    {
        this.keysFactory = keysFactory;
    }

    public async Task OnSubscribed(TTopic topic, LeanPipe pipe)
    {
        var keys = keysFactory.ToKeys(topic);
        foreach (var key in keys)
        {
            await pipe.Groups.AddToGroupAsync(pipe.Context.ConnectionId, key);
        }
    }

    public async Task OnUnsubscribed(TTopic topic, LeanPipe pipe)
    {
        // with this implementation there is a problem of "higher level" groups:
        // if we subscribe to topic.something and topic.something.specific,
        // then we do not know when to unsubscribe from topic.something
        var keys = keysFactory.ToKeys(topic);
        foreach (var key in keys)
        {
            await pipe.Groups.RemoveFromGroupAsync(pipe.Context.ConnectionId, key);
        }
    }
}
