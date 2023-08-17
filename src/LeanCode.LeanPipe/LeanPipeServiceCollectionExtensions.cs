using System.Reflection;
using System.Text;
using System.Text.Json;
using LeanCode.Components;
using LeanCode.Contracts;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Http.Connections;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanCode.LeanPipe.Extensions;

public static class LeanPipeServiceCollectionExtensions
{
    public static LeanPipeServicesBuilder AddLeanPipe(
        this IServiceCollection services,
        TypesCatalog topics,
        TypesCatalog handlers
    )
    {
        services
            .AddSignalR()
            .AddJsonProtocol(
                options => options.PayloadSerializerOptions.PropertyNamingPolicy = null
            );

        services.AddTransient(typeof(ISubscriptionHandler<>), typeof(KeyedSubscriptionHandler<>));
        services.AddTransient(typeof(LeanPipePublisher<>), typeof(LeanPipePublisher<>));
        services.AddTransient<SubscriptionHandlerResolver>();

        return new LeanPipeServicesBuilder(services, topics).AddHandlers(handlers);
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

public class LeanPipeServicesBuilder
{
    public IServiceCollection Services { get; }

    private JsonSerializerOptions? options;
    private TypesCatalog topics;

    public LeanPipeServicesBuilder(IServiceCollection services, TypesCatalog topics)
    {
        Services = services;
        this.topics = topics;

        Services.AddSingleton<IEnvelopeDeserializer>(new DefaultEnvelopeDeserializer(topics, null));
    }

    public LeanPipeServicesBuilder WithEnvelopeDeserializerOptions(JsonSerializerOptions options)
    {
        this.options = options;
        ReplaceDefaultEnvelopeDeserializer();
        return this;
    }

    public LeanPipeServicesBuilder WithEnvelopeDeserializer(IEnvelopeDeserializer deserializer)
    {
        Services.Replace(new ServiceDescriptor(typeof(IEnvelopeDeserializer), deserializer));
        return this;
    }

    public LeanPipeServicesBuilder AddTopics(TypesCatalog newTopics)
    {
        topics = topics.Merge(newTopics);
        ReplaceDefaultEnvelopeDeserializer();
        return this;
    }

    public LeanPipeServicesBuilder AddHandlers(TypesCatalog newHandlers)
    {
        Services.RegisterGenericTypes(
            newHandlers,
            typeof(ISubscriptionHandler<>),
            ServiceLifetime.Transient
        );
        Services.RegisterGenericTypes(
            newHandlers,
            typeof(ITopicController<>),
            ServiceLifetime.Transient
        );
        Services.RegisterGenericTypes(
            newHandlers,
            typeof(ITopicController<,>),
            ServiceLifetime.Transient
        );
        return this;
    }

    private void ReplaceDefaultEnvelopeDeserializer()
    {
        for (var i = Services.Count - 1; i >= 0; i--)
        {
            var descriptor = Services[i];
            if (
                descriptor.ServiceType == typeof(IEnvelopeDeserializer)
                && descriptor.ImplementationInstance is DefaultEnvelopeDeserializer
            )
            {
                Services.RemoveAt(i);
                Services.AddSingleton<IEnvelopeDeserializer>(
                    new DefaultEnvelopeDeserializer(topics, options)
                );
                break;
            }
        }
    }
}
