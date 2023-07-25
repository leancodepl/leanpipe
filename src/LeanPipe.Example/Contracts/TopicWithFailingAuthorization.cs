using LeanCode.Contracts;
using LeanCode.Contracts.Security;
using LeanPipe.Example.Handlers.Authorizers;

namespace LeanPipe.Example.Contracts;

[AllowNone]
public class TopicWithFailingAuthorization : ITopic { }

public class AllowNone : AuthorizeWhenAttribute
{
    public AllowNone()
        : base(typeof(AlwaysFailingAuthorizer)) { }
}
