using LeanCode.Contracts;
using Microsoft.AspNetCore.SignalR;

namespace LeanCode.LeanPipe;

public class LeanPipe(IKeysFactory<ITopic> keysFactory) : Hub
{
    private readonly IKeysFactory<ITopic> keysFactory = keysFactory;

    public async Task SubscribeAsync(ITopic topic)
    {
        var keys = keysFactory.ToKeys(topic);
        foreach (var key in keys)
        {
            await Groups.AddToGroupAsync(Context.ConnectionId, key);
        }
    }

    public async Task UnSubscribeAsync(ITopic topic)
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
