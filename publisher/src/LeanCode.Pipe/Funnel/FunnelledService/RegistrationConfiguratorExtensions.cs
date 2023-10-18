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
    /// <param name="assembliesWithTopics">Assemblies that contain all topics exposed by the service.</param>
    /// <param name="funnelledSubscriberDefinitionOverride">
    /// Optional definition override for subscriber consumers.
    /// Should inherit <see cref="FunnelledSubscriber{TTopic}"/> and be generic of the topics.
    /// </param>
    public static void AddFunnelledLeanPipeConsumers(
        this IRegistrationConfigurator configurator,
        IEnumerable<Assembly> assembliesWithTopics,
        Type? funnelledSubscriberDefinitionOverride = null,
        Type? topicExistenceCheckerDefinitionOverride = null
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
            types,
            funnelledSubscriberDefinitionOverride,
            topicExistenceCheckerDefinitionOverride
        );
    }

    public static void AddFunnelledLeanPipeConsumers(
        this IRegistrationConfigurator configurator,
        Type[] topicTypes,
        Type? funnelledSubscriberDefinitionOverride,
        Type? topicExistenceCheckerDefinitionOverride
    )
    {
        var topicExistenceCheckerDefinition =
            topicExistenceCheckerDefinitionOverride ?? typeof(TopicExistenceCheckerDefinition);

        if (
            !topicExistenceCheckerDefinition.IsAssignableTo(typeof(TopicExistenceCheckerDefinition))
        )
        {
            throw new ArgumentException(
                "TopicExistenceChecker definition override is not compatible. "
                    + "It needs to derive from TopicExistenceCheckerDefinition.",
                nameof(funnelledSubscriberDefinitionOverride)
            );
        }

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
                e.InstanceId =
                    "_"
                    + (Assembly.GetEntryAssembly()?.GetName().Name ?? Guid.NewGuid().ToString());
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

        return interfaces.Any(t => t.HasInterface(typeof(ITopic)));
    }
}
