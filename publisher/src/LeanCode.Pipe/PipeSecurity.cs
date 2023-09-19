using LeanCode.Contracts;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;
using Microsoft.AspNetCore.Http;

namespace LeanCode.Pipe;

internal static class PipeSecurity
{
    public static async Task<bool> CheckIfAuthorizedAsync(ITopic topic, HttpContext context)
    {
        var topicType = topic.GetType();
        var customAuthorizers = AuthorizeWhenAttribute.GetCustomAuthorizers(topicType);
        var user = context.User;

        if (customAuthorizers.Count > 0 && !(user?.Identity?.IsAuthenticated ?? false))
        {
            return false;
        }

        foreach (var customAuthorizerDefinition in customAuthorizers)
        {
            var authorizerType = customAuthorizerDefinition.Authorizer;
            var customAuthorizer = context.RequestServices.GetService(authorizerType);

            if (customAuthorizer is ICustomAuthorizer authorizer)
            {
                var authorized = await authorizer.CheckIfAuthorizedAsync(
                    context,
                    topic,
                    customAuthorizerDefinition.CustomData
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
