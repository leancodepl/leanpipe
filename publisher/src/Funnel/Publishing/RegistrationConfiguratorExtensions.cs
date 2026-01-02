using System.Reflection;
using LeanCode.Components;
using LeanCode.Contracts;
using MassTransit;
using MassTransit.Internals;
using MassTransit.Util;

namespace LeanCode.Pipe.Funnel.Publishing;

public static class RegistrationConfiguratorExtensions
{
    /// <inheritdoc cref="AddFunnelledLeanPipeConsumers(IRegistrationConfigurator,string,Type[],Type?)"/>
    /// <param name="leanPipeBuilder">Preconfigured LeanPipe services builder containing topics exposed by the service.</param>
    public static IRegistrationConfigurator AddFunnelledLeanPipeConsumers(
        this IRegistrationConfigurator configurator,
        string serviceName,
        LeanPipeServicesBuilder leanPipeBuilder,
        Type? funnelledSubscriberDefinitionOverride = null
    )
    {
        return configurator.AddFunnelledLeanPipeConsumers(
            serviceName,
            leanPipeBuilder.Topics,
            funnelledSubscriberDefinitionOverride
        );
    }

    /// <inheritdoc cref="AddFunnelledLeanPipeConsumers(IRegistrationConfigurator,string,Type[],Type?)"/>
    /// <param name="topics">Catalog of topics exposed by the service.</param>
    public static IRegistrationConfigurator AddFunnelledLeanPipeConsumers(
        this IRegistrationConfigurator configurator,
        string serviceName,
        TypesCatalog topics,
        Type? funnelledSubscriberDefinitionOverride = null
    )
    {
        return configurator.AddFunnelledLeanPipeConsumers(
            serviceName,
            topics.Assemblies,
            funnelledSubscriberDefinitionOverride
        );
    }

    /// <inheritdoc cref="AddFunnelledLeanPipeConsumers(IRegistrationConfigurator,string,Type[],Type?)"/>
    /// <param name="assembliesWithTopics">Assemblies that contain all topics exposed by the service.</param>
    public static IRegistrationConfigurator AddFunnelledLeanPipeConsumers(
        this IRegistrationConfigurator configurator,
        string serviceName,
        IEnumerable<Assembly> assembliesWithTopics,
        Type? funnelledSubscriberDefinitionOverride = null
    )
    {
        var result = AssemblyTypeCache
            .FindTypes(assembliesWithTopics, IsTopic)
            .GetAwaiter()
            .GetResult();

        var types = result
            .FindTypes(TypeClassification.Closed | TypeClassification.Concrete)
            .ToArray();

        return configurator.AddFunnelledLeanPipeConsumers(
            serviceName,
            types,
            funnelledSubscriberDefinitionOverride
        );
    }

    /// <summary>
    /// Configures a consumer for each topic in the provided assemblies that will handle subscriptions
    /// in the LeanPipe with Funnel model.
    /// </summary>
    /// <param name="configurator">MassTransit bus registration configurator.</param>
    /// <param name="serviceName">Funnelled service name.</param>
    /// <param name="topicTypes">All topics exposed by the service.</param>
    /// <param name="funnelledSubscriberDefinitionOverride">
    /// Optional definition override for subscriber consumers.
    /// Should inherit <see cref="FunnelledSubscriber{TTopic}"/> and be generic of the topics.
    /// </param>
    public static IRegistrationConfigurator AddFunnelledLeanPipeConsumers(
        this IRegistrationConfigurator configurator,
        string serviceName,
        Type[] topicTypes,
        Type? funnelledSubscriberDefinitionOverride
    )
    {
        var subscriberDefinition =
            funnelledSubscriberDefinitionOverride ?? typeof(FunnelledSubscriberDefinition<>);

        if (
            !subscriberDefinition.IsGenericTypeDefinition
            || subscriberDefinition.GetGenericArguments().Length != 1
        )
        {
            throw new ArgumentException(
                "LeanPipe funnelled subscriber definition override is not compatible. "
                    + "It needs to be a generic type with a single generic argument that denotes the consumer.",
                nameof(funnelledSubscriberDefinitionOverride)
            );
        }

        configurator
            .AddConsumer<TopicExistenceChecker>()
            .Endpoint(e =>
            {
                // Each service gets its own queue (for fan-out across different services)
                // but replicas of the same service share the queue (competing consumers)
                // Don't use Temporary=true as it creates exclusive queues that break scaling on RabbitMQ
                e.InstanceId = $"_{serviceName}";
            });

        foreach (var topicType in topicTypes)
        {
            var consumerType = typeof(FunnelledSubscriber<>).MakeGenericType(topicType);
            var consumerDefinitionType = subscriberDefinition.MakeGenericType(topicType);
            configurator.AddConsumer(consumerType, consumerDefinitionType);
        }

        return configurator;
    }

    private static bool IsTopic(Type type)
    {
        var interfaces = type.GetTypeInfo().GetInterfaces();

        return interfaces.Any(t => t.HasInterface<ITopic>());
    }
}
