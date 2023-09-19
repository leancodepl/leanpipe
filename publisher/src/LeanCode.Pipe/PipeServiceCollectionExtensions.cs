using System.Text.Json;
using LeanCode.Components;
using LeanCode.Contracts;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanCode.Pipe;

public static class PipeServiceCollectionExtensions
{
    public static PipeServicesBuilder AddPipe(
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
        services.AddTransient(typeof(PipePublisher<>), typeof(PipePublisher<>));
        services.AddTransient<SubscriptionHandlerResolver>();

        return new PipeServicesBuilder(services, topics).AddHandlers(handlers);
    }
}

public class PipeServicesBuilder
{
    public IServiceCollection Services { get; }

    private JsonSerializerOptions? options;
    private TypesCatalog topics;

    public PipeServicesBuilder(IServiceCollection services, TypesCatalog topics)
    {
        Services = services;
        this.topics = topics;

        Services.AddSingleton<IEnvelopeDeserializer>(new DefaultEnvelopeDeserializer(topics, null));
    }

    public PipeServicesBuilder WithEnvelopeDeserializerOptions(JsonSerializerOptions options)
    {
        this.options = options;
        ReplaceDefaultEnvelopeDeserializer();
        return this;
    }

    public PipeServicesBuilder WithEnvelopeDeserializer(IEnvelopeDeserializer deserializer)
    {
        Services.Replace(new ServiceDescriptor(typeof(IEnvelopeDeserializer), deserializer));
        return this;
    }

    public PipeServicesBuilder AddTopics(TypesCatalog newTopics)
    {
        topics = topics.Merge(newTopics);
        ReplaceDefaultEnvelopeDeserializer();
        return this;
    }

    public PipeServicesBuilder AddHandlers(TypesCatalog newHandlers)
    {
        Services.RegisterGenericTypes(
            newHandlers,
            typeof(ISubscriptionHandler<>),
            ServiceLifetime.Transient
        );
        Services.RegisterGenericTypes(newHandlers, typeof(ITopicKeys<>), ServiceLifetime.Transient);
        Services.RegisterGenericTypes(
            newHandlers,
            typeof(INotificationKeys<,>),
            ServiceLifetime.Transient
        );
        VerifyNotificationKeysImplementations();
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

    private void VerifyNotificationKeysImplementations()
    {
        var notificationKeysType = typeof(INotificationKeys<,>);
        var typesToCheck = new HashSet<(Type, Type)>();

        foreach (var service in Services)
        {
            if (
                service.ServiceType.IsGenericType
                && service.ServiceType.GetGenericTypeDefinition() == notificationKeysType
                && (service.ImplementationType ?? service.ImplementationInstance?.GetType())
                    is { } implementationType
            )
            {
                var topicType = service.ServiceType.GenericTypeArguments[0];
                typesToCheck.Add((topicType, implementationType));
            }
        }

        foreach (var (topicType, keysType) in typesToCheck)
        {
            VerifyNotificationKeys(topicType, keysType);
        }
    }

    private static void VerifyNotificationKeys(Type topicType, Type keysType)
    {
        var producedNotifications = topicType
            .FindInterfaces(Filter, typeof(IProduceNotification<>))
            .Select(t => t.GenericTypeArguments[0])
            .ToHashSet();
        var implementedKeys = keysType
            .FindInterfaces(Filter, typeof(INotificationKeys<,>))
            .Select(t => t.GenericTypeArguments[1])
            .ToHashSet();

        var missing = producedNotifications.Except(implementedKeys);

        if (implementedKeys.Count > 0 && missing.Any())
        {
            var msg = $"""
            If topic keys implements `INotificationKeys`, it needs to be implemented for all notification types.
            The class `{keysType.FullName}` is missing following implementations:
            {string.Join(", ", missing.Select(t => $"  - INotificationKeys<{topicType.Name}, {t.Name}>"))}
            """;
            throw new InvalidOperationException(msg);
        }

        static bool Filter(Type i, object? c) =>
            i.IsAbstract && i.IsGenericType && i.GetGenericTypeDefinition() == (Type)c!;
    }
}
