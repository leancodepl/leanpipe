using System.Reflection;
using System.Text;
using LeanCode.Contracts;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http.Connections;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanCode.LeanPipe.Extensions;

public static class LeanPipeExtensions
{
    public static IServiceCollection AddLeanPipe(this IServiceCollection services) =>
        services.AddLeanPipe(typeof(DefaultEnvelopeDeserializer));

    public static IServiceCollection AddLeanPipe(
        this IServiceCollection services,
        Type envelopeDeserializer
    )
    {
        services.AddSignalR();
        services.TryAddTransient(typeof(IEnvelopeDeserializer), envelopeDeserializer);
        services.AddTransient(typeof(ISubscriptionHandler<>), typeof(KeyedSubscriptionHandler<>));
        services.AddTransient(typeof(LeanPipePublisher<,>), typeof(LeanPipePublisher<,>));
        services.AddTransient(
            typeof(ISubscriptionHandlerResolver<>),
            typeof(SubscriptionHandlerResolver<>)
        );
        return services;
    }

    public static IServiceCollection AddKeysFactory<TTopic>(
        this IServiceCollection services,
        Type factory
    )
        where TTopic : ITopic
    {
        services.AddTransient(typeof(IKeysFactory<TTopic>), factory);
        var filter = new TypeFilter(
            (i, c) => i.IsAbstract && i.IsGenericType && i.GetGenericTypeDefinition() == (Type)c!
        );
        var topicInterfaces = typeof(TTopic).FindInterfaces(filter, typeof(IProduceNotification<>));
        var factoryInterfaces = factory.FindInterfaces(filter, typeof(IKeysFactory<,>));

        var topicNotifications = topicInterfaces
            .Select(t => t.GetGenericArguments().First())
            .ToHashSet();
        var factoryNotifications = factoryInterfaces
            .Select(t => t.GetGenericArguments().ElementAt(1))
            .ToHashSet();
        var missing = topicNotifications.Except(factoryNotifications);

        if (missing.Any())
        {
            var msg = new StringBuilder(
                "Keys factory should implement the same notification-related interfaces as it's topic; "
            );
            var fmt = (Type t) =>
                $"{typeof(IKeysFactory<,>).Name.Split('`').First()}<{typeof(TTopic).Name}, {t.Name}>";
            msg.AppendFormat(
                "'{0}' is missing following implementations: {1}",
                factory.Name,
                string.Join(", ", missing.Select(fmt))
            );
            throw new InvalidOperationException(msg.Append('.').ToString());
        }

        foreach (var @interface in factoryInterfaces)
        {
            services.AddTransient(@interface, factory);
        }
        return services;
    }

    public static IServiceCollection AddSubscriptionHandler<TTopic>(
        this IServiceCollection services,
        Type handler
    )
        where TTopic : ITopic
    {
        services.AddTransient(typeof(ISubscriptionHandler<TTopic>), handler);
        return services;
    }

    public static IServiceCollection AddSubscriptionHandler<TTopic>(
        this IServiceCollection services,
        Type handler,
        Type factory
    )
        where TTopic : ITopic
    {
        services.AddKeysFactory<TTopic>(factory);
        services.AddTransient(typeof(ISubscriptionHandler<TTopic>), handler);
        return services;
    }

    public static IHubEndpointConventionBuilder MapLeanPipe(
        this IEndpointRouteBuilder endpoints,
        string pattern
    )
    {
        return endpoints.MapHub<LeanPipeSubscriber>(pattern);
    }

    public static IHubEndpointConventionBuilder MapLeanPipe(
        this IEndpointRouteBuilder endpoints,
        string pattern,
        Action<HttpConnectionDispatcherOptions>? configureOptions
    )
    {
        return endpoints.MapHub<LeanPipeSubscriber>(pattern, configureOptions);
    }
}
