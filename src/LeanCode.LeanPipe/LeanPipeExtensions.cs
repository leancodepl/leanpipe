using System.Reflection;
using System.Text;
using System.Text.Json;
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
        services
            .AddSignalR()
            .AddJsonProtocol(
                options => options.PayloadSerializerOptions.PropertyNamingPolicy = null
            );
        services.TryAddTransient(typeof(IEnvelopeDeserializer), envelopeDeserializer);
        services.AddTransient(typeof(ISubscriptionHandler<>), typeof(KeyedSubscriptionHandler<>));
        services.AddTransient(typeof(LeanPipePublisher<>), typeof(LeanPipePublisher<>));
        services.AddTransient(
            typeof(ISubscriptionHandlerResolver<>),
            typeof(SubscriptionHandlerResolver<>)
        );
        return services;
    }

    public static IServiceCollection AddTopicController<TTopic, TController>(
        this IServiceCollection services
    )
        where TTopic : ITopic
        where TController : ITopicController<TTopic>
    {
        var factory = typeof(TController);
        services.AddTransient(typeof(ITopicController<TTopic>), factory);
        var filter = new TypeFilter(
            (i, c) => i.IsAbstract && i.IsGenericType && i.GetGenericTypeDefinition() == (Type)c!
        );
        var topicInterfaces = typeof(TTopic).FindInterfaces(filter, typeof(IProduceNotification<>));
        var factoryInterfaces = factory.FindInterfaces(filter, typeof(ITopicController<,>));

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
                "Topic controller should implement the same notification-related interfaces as it's topic; "
            );
            var fmt = (Type t) =>
                $"{typeof(ITopicController<,>).Name.Split('`').First()}<{typeof(TTopic).Name}, {t.Name}>";
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

    public static IServiceCollection AddTopicControllerWithDefaults<TTopic, TController>(
        this IServiceCollection services
    )
        where TTopic : ITopic
        where TController : ITopicController<TTopic>
    {
        services.AddTransient(typeof(ITopicController<TTopic>), typeof(TController));
        return services;
    }

    public static IServiceCollection AddSubscriptionHandler<TTopic, THandler>(
        this IServiceCollection services
    )
        where TTopic : ITopic
        where THandler : ISubscriptionHandler<TTopic>
    {
        services.AddTransient(typeof(ISubscriptionHandler<TTopic>), typeof(THandler));
        return services;
    }

    public static IServiceCollection AddHandlerAndFactory<TTopic, TController, THandler>(
        this IServiceCollection services
    )
        where TTopic : ITopic
        where TController : ITopicController<TTopic>
        where THandler : ISubscriptionHandler<TTopic>
    {
        services.AddTopicController<TTopic, TController>();
        services.AddSubscriptionHandler<TTopic, THandler>();
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
