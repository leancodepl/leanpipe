using LeanCode.Contracts;

namespace LeanCode.LeanPipe;

public interface IKeysFactory<in TTopic>
    where TTopic : ITopic
{
    IEnumerable<string> ToKeys(TTopic topic);
}
