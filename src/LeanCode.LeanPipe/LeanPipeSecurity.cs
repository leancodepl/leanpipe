using LeanCode.Contracts;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;

namespace LeanCode.LeanPipe;

internal static class LeanPipeSecurity
{
    internal static async Task<bool> CheckIfAuthorizedAsync(ITopic topic, LeanPipeContext context)
    {
        var topicType = topic.GetType();
        var customAuthorizers = AuthorizeWhenAttribute.GetCustomAuthorizers(topicType);
        var user = context.HttpContext.User;

        if (customAuthorizers.Count > 0 && !(user?.Identity?.IsAuthenticated ?? false))
        {
            return false;
        }

        foreach (var customAuthorizerDefinition in customAuthorizers)
        {
            var authorizerType = customAuthorizerDefinition.Authorizer;

            if (
                context.HttpContext.RequestServices.GetService(authorizerType)
                is not ICustomAuthorizer customAuthorizer
            )
            {
                throw new CustomAuthorizerNotFoundException(authorizerType);
            }

            var authorized = await customAuthorizer.CheckIfAuthorizedAsync(
                context.HttpContext,
                topic,
                customAuthorizerDefinition.CustomData
            );

            if (!authorized)
            {
                return false;
            }
        }

        return true;
    }
}
