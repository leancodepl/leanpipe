using System.Reflection;
using LeanCode.Contracts;
using MassTransit;
using MassTransit.Internals;
using MassTransit.Util;

namespace LeanCode.Pipe.Funnel.FunnelledService;

public static class RegistrationConfiguratorExtensions
{
    /// <summary>
    /// Configures a consumer for each topic in the provided assemblies that will handle subscriptions
    /// in the LeanPipe with Funnel model.
    /// </summary>
    /// <param name="configurator">MassTransit bus registration configurator.</param>
    /// <param name="serviceName">Funnelled service name.</param>
    /// <param name="assembliesWithTopics">Assemblies that contain all topics exposed by the service.</param>
    /// <param name="funnelledSubscriberDefinitionOverride">
    /// Optional definition override for subscriber consumers.
    /// Should inherit <see cref="FunnelledSubscriber{TTopic}"/> and be generic of the topics.
    /// </param>
    public static void AddFunnelledLeanPipeConsumers(
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

        configurator.AddFunnelledLeanPipeConsumers(
            serviceName,
            types,
            funnelledSubscriberDefinitionOverride
        );
    }

    public static void AddFunnelledLeanPipeConsumers(
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
                e.Temporary = true;
                // Include hostname to make queue unique per instance when scaling (only an issue for RabbitMQ)
                var hostname =
                    Environment.GetEnvironmentVariable("HOSTNAME") ?? Environment.MachineName;
                e.InstanceId = $"_{serviceName}_{hostname}";
            });

        foreach (var topicType in topicTypes)
        {
            var consumerType = typeof(FunnelledSubscriber<>).MakeGenericType(topicType);
            var consumerDefinitionType = subscriberDefinition.MakeGenericType(topicType);
            configurator.AddConsumer(consumerType, consumerDefinitionType);
        }
    }

    private static bool IsTopic(Type type)
    {
        var interfaces = type.GetTypeInfo().GetInterfaces();

        return interfaces.Any(t => t.HasInterface<ITopic>());
    }
}
