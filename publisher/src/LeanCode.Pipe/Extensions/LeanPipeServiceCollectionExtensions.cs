using System.Text.Json;
using LeanCode.Components;
using LeanCode.Contracts;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.DependencyInjection.Extensions;

namespace LeanCode.Pipe;

public static class LeanPipeServiceCollectionExtensions
{
    /// <summary>
    /// Adds all classes required for LeanPipe to function to DI.
    /// </summary>
    /// <returns>Service builder allowing for overriding default LeanPipe implementations
    /// and further configuration.</returns>
    public static LeanPipeServicesBuilder AddLeanPipe(
        this IServiceCollection services,
        TypesCatalog topics,
        TypesCatalog handlers
    )
    {
        services
            .AddSignalR()
            .AddJsonProtocol(options =>
                options.PayloadSerializerOptions.PropertyNamingPolicy = null
            );

        services.AddTransient<LeanPipeSecurity>();
        services.AddTransient<ISubscriptionExecutor, SubscriptionExecutor>();
        services.AddTransient(typeof(ISubscriptionHandler<>), typeof(KeyedSubscriptionHandler<>));
        services.AddTransient(typeof(ILeanPipePublisher<>), typeof(LeanPipePublisher<>));
        services.AddTransient<SubscriptionHandlerResolver>();

        return new LeanPipeServicesBuilder(services, topics).AddHandlers(handlers);
    }
}

/// <summary>
/// Allows for overriding default LeanPipe implementations
/// and further configuration.
/// </summary>
public class LeanPipeServicesBuilder
{
    public IServiceCollection Services { get; }
    public TypesCatalog Topics { get; private set; }

    private JsonSerializerOptions? options;

    public LeanPipeServicesBuilder(IServiceCollection services, TypesCatalog topics)
    {
        Services = services;
        Topics = topics;

        Services.AddSingleton<ITopicExtractor>(new DefaultTopicExtractor(topics, null));
    }

    /// <summary>
    /// Overrides serializing options used in subscription envelope deserializer.
    /// </summary>
    public LeanPipeServicesBuilder WithEnvelopeDeserializerOptions(JsonSerializerOptions options)
    {
        this.options = options;
        ReplaceDefaultEnvelopeDeserializer();
        return this;
    }

    /// <summary>
    /// Overrides subscription envelope deserializer.
    /// </summary>
    public LeanPipeServicesBuilder WithEnvelopeDeserializer(ITopicExtractor deserializer)
    {
        Services.Replace(new ServiceDescriptor(typeof(ITopicExtractor), deserializer));
        return this;
    }

    /// <summary>
    /// Adds topics from another <see cref="TypesCatalog"/>.
    /// </summary>
    public LeanPipeServicesBuilder AddTopics(TypesCatalog newTopics)
    {
        Topics = Topics.Merge(newTopics);
        ReplaceDefaultEnvelopeDeserializer();
        return this;
    }

    /// <summary>
    /// Adds subscription handlers and keys generators from another <see cref="TypesCatalog"/>.
    /// </summary>
    public LeanPipeServicesBuilder AddHandlers(TypesCatalog newHandlers)
    {
        Services.RegisterGenericTypes(
            newHandlers,
            typeof(ISubscriptionHandler<>),
            ServiceLifetime.Transient
        );
        Services.RegisterGenericTypes(
            newHandlers,
            typeof(ISubscribingKeys<>),
            ServiceLifetime.Transient
        );
        Services.RegisterGenericTypes(
            newHandlers,
            typeof(IPublishingKeys<,>),
            ServiceLifetime.Transient
        );
        VerifyPublishingKeysImplementations();
        return this;
    }

    private void ReplaceDefaultEnvelopeDeserializer()
    {
        for (var i = Services.Count - 1; i >= 0; i--)
        {
            var descriptor = Services[i];
            if (
                descriptor.ServiceType == typeof(ITopicExtractor)
                && descriptor.ImplementationInstance is DefaultTopicExtractor
            )
            {
                Services.RemoveAt(i);
                Services.AddSingleton<ITopicExtractor>(new DefaultTopicExtractor(Topics, options));
                break;
            }
        }
    }

    private void VerifyPublishingKeysImplementations()
    {
        var notificationKeysType = typeof(IPublishingKeys<,>);
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
            VerifyPublishingKeys(topicType, keysType);
        }
    }

    private static void VerifyPublishingKeys(Type topicType, Type keysType)
    {
        var producedNotifications = topicType
            .FindInterfaces(Filter, typeof(IProduceNotification<>))
            .Select(t => t.GenericTypeArguments[0])
            .ToHashSet();
        var implementedKeys = keysType
            .FindInterfaces(Filter, typeof(IPublishingKeys<,>))
            .Select(t => t.GenericTypeArguments[1])
            .ToHashSet();

        var missing = producedNotifications.Except(implementedKeys);

        if (implementedKeys.Count > 0 && missing.Any())
        {
            var msg = $"""
                Topic must have implemented `IPublishingKeys` for all notification types.
                The class `{keysType.FullName}` is missing following implementations:
                {string.Join(
                    ", ",
                    missing.Select(t => $"  - IPublishingKeys<{topicType.Name}, {t.Name}>")
                )}
                """;
            throw new InvalidOperationException(msg);
        }

        static bool Filter(Type i, object? c) =>
            i.IsAbstract && i.IsGenericType && i.GetGenericTypeDefinition() == (Type)c!;
    }
}
