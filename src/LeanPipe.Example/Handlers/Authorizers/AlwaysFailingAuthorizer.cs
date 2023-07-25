using LeanCode.CQRS.Security;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers.Authorizers;

public class AlwaysFailingAuthorizer : CustomAuthorizer<TopicWithFailingAuthorization>
{
    protected override Task<bool> CheckIfAuthorizedAsync(
        HttpContext httpContext,
        TopicWithFailingAuthorization obj
    )
    {
        return Task.FromResult(false);
    }
}
