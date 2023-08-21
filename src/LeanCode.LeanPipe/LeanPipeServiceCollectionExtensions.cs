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
        Services.RegisterGenericTypes(newHandlers, typeof(ITopicKeys<>), ServiceLifetime.Transient);
        Services.RegisterGenericTypes(
            newHandlers,
            typeof(INotificationKeys<,>),
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
