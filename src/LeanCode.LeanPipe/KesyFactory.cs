using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public interface IKeysFactory<in TTopic>
    where TTopic : ITopic
{
    IEnumerable<string> ToKeys(TTopic topic);
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
