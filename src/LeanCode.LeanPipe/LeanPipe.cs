using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

// with  this generic model we'd need to have LeanPipe<TTopic1, TTopic2, ...> overloads
// which is ranter not very nice, maybe we could come up with a better model
public abstract class LeanPipe<TTopic>(IKeysFactory<TTopic> keysFactory) : Hub
    where TTopic : ITopic
{
    private readonly IKeysFactory<TTopic> keysFactory = keysFactory;

    public async Task SubscribeAsync(TTopic topic)
    {
        var keys = keysFactory.ToKeys(topic);
        foreach (var key in keys)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, key);
        }
    }

    public async Task UnSubscribeAsync(TTopic topic)
    {
        // with this implementation there is a problem of "higher level" groups:
        // if we subscribe to topic.something and topic.something.specific,
        // then we do not know when to unsubscribe from topic.something
        var keys = keysFactory.ToKeys(topic);
        foreach (var key in keys)
        {
            await Groups.RemoveFromGroupAsync(Context.ConnectionId, key);
        }
    }
}
