using System.Security.Claims;
using LeanCode.Contracts;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;

namespace LeanCode.Pipe;

public class LeanPipeSecurity
{
    private readonly IServiceProvider serviceProvider;

    public LeanPipeSecurity(IServiceProvider serviceProvider)
    {
        this.serviceProvider = serviceProvider;
    }

    public async Task<bool> CheckIfAuthorizedAsync(
        ITopic topic,
        ClaimsPrincipal user,
        CancellationToken ct
    )
    {
        var topicType = topic.GetType();
        var customAuthorizers = AuthorizeWhenAttribute.GetCustomAuthorizers(topicType);

        if (customAuthorizers.Count > 0 && !(user.Identity?.IsAuthenticated ?? false))
        {
            return false;
        }

        foreach (var customAuthorizerDefinition in customAuthorizers)
        {
            var authorizerType = customAuthorizerDefinition.Authorizer;
            var customAuthorizer = serviceProvider.GetService(authorizerType);

            if (customAuthorizer is ICustomAuthorizer authorizer)
            {
                var authorized = await authorizer.CheckIfAuthorizedAsync(
                    user,
                    topic,
                    customAuthorizerDefinition.CustomData,
                    ct
                );

                if (!authorized)
                {
                    return false;
                }
            }
            else
            {
                throw new CustomAuthorizerNotFoundException(authorizerType);
            }
        }

        return true;
    }
}
