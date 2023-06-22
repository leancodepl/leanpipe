using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public interface IKeysFactory<TTopic>
    where TTopic : ITopic
{
    // possibly different subscribe-, unsubscribe-, and send-specific methods
    HashSet<string> ToKeys(TTopic topic);
}

public class DefaultKeysFactory<TTopic>
    where TTopic : ITopic
{
    public virtual HashSet<string> ToKeys(TTopic topic)
    {
        return new HashSet<string>()
        {
            topic.ToString()
                ?? throw new InvalidOperationException(
                    "Topic must provide a valid string representation"
                )
        };
    }
}
