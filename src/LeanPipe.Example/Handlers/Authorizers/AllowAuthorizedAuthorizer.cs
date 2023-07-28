using LeanCode.CQRS.Security;
using LeanPipe.Example.Contracts;

namespace LeanPipe.Example.Handlers.Authorizers;

public class AllowAuthorizedAuthorizer : CustomAuthorizer<Auction>
{
    protected override Task<bool> CheckIfAuthorizedAsync(HttpContext httpContext, Auction obj)
    {
        return Task.FromResult(obj.Authorized);
    }
}
