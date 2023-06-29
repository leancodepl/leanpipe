using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

/// <summary>
/// Marker interface, do not use directly
/// </summary>
public interface IKeysFactory<in TTopic>
    where TTopic : ITopic
{
    Task<IEnumerable<string>> ToKeysAsync(TTopic topic);
}

public interface IKeysFactory<in TTopic, TNotification> : IKeysFactory<TTopic>
    where TTopic : ITopic, IProduceNotification<TNotification>
    where TNotification : notnull
{
    Task<IEnumerable<string>> ToKeysAsync(TTopic topic, TNotification notification) =>
        ToKeysAsync(topic);
}
