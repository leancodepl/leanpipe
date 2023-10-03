using System.Reflection;
using LeanCode.Contracts;
using MassTransit;
using MassTransit.Internals;
using MassTransit.Util;

namespace LeanCode.Pipe.Funnel.FunnelledService;

public static class RegistrationConfiguratorExtensions
{
    public static void AddFunnelledLeanPipeConsumers(
        this IRegistrationConfigurator configurator,
        IEnumerable<Assembly> assembliesWithTopics
    )
    {
        var result = AssemblyTypeCache
            .FindTypes(assembliesWithTopics, IsTopic)
            .GetAwaiter()
            .GetResult();

        var types = result
            .FindTypes(TypeClassification.Closed | TypeClassification.Concrete)
            .ToArray();

        configurator.AddFunnelledLeanPipeConsumers(types);
    }

    public static void AddFunnelledLeanPipeConsumers(
        this IRegistrationConfigurator configurator,
        Type[] topicTypes
    )
    {
        foreach (var topicType in topicTypes)
        {
            var consumerType = typeof(FunnelledSubscriber<>).MakeGenericType(topicType);

            // TODO: Make this overridable if other consumer definition exists in some assemblies
            var consumerDefinitionType = typeof(FunnelledSubscriberDefinition<>).MakeGenericType(
                topicType
            );

            configurator.AddConsumer(consumerType, consumerDefinitionType);
        }
    }

    private static bool IsTopic(Type type)
    {
        var interfaces = type.GetTypeInfo().GetInterfaces();

        return interfaces.Any(t => t.HasInterface(typeof(ITopic)));
    }
}
