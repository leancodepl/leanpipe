using LeanCode.Contracts;
using LeanCode.Contracts.Security;
using LeanCode.CQRS.Security;
using LeanCode.CQRS.Security.Exceptions;

namespace LeanCode.LeanPipe;

internal static class LeanPipeSecurity
{
    internal static async Task AuthorizeAsync(ITopic topic, LeanPipeContext context)
    {
        var topicType = topic.GetType();
        var customAuthorizers = AuthorizeWhenAttribute.GetCustomAuthorizers(topicType);
        var user = context.HttpContext.User;

        if (customAuthorizers.Count > 0 && !(user?.Identity?.IsAuthenticated ?? false))
        {
            throw new UnauthenticatedException(
                $"User is not authenticated and the topic {topicType.FullName} requires authorization."
            );
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
                throw new InsufficientPermissionException(
                    $"User is not authorized for topic {topicType.FullName}, authorizer {authorizerType.FullName} did not pass.",
                    authorizerType.FullName
                );
            }
        }
    }
}
