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

        configurator.AddFunnelledLeanPipeConsumers(types, funnelledSubscriberDefinitionOverride);
    }

    public static void AddFunnelledLeanPipeConsumers(
        this IRegistrationConfigurator configurator,
        Type[] topicTypes,
        Type? funnelledSubscriberDefinitionOverride
    )
    {
        var definitionType =
            funnelledSubscriberDefinitionOverride ?? typeof(FunnelledSubscriberDefinition<>);

        if (
            !definitionType.IsGenericTypeDefinition
            || definitionType.GetGenericArguments().Length != 1
        )
        {
            throw new ArgumentException(
                "LeanPipe funnelled subscriber definition override is not compatible",
                nameof(funnelledSubscriberDefinitionOverride)
            );
        }

        foreach (var topicType in topicTypes)
        {
            var consumerType = typeof(FunnelledSubscriber<>).MakeGenericType(topicType);

            var consumerDefinitionType = definitionType.MakeGenericType(topicType);

            configurator.AddConsumer(consumerType, consumerDefinitionType);
        }
    }

    private static bool IsTopic(Type type)
    {
        var interfaces = type.GetTypeInfo().GetInterfaces();

        return interfaces.Any(t => t.HasInterface(typeof(ITopic)));
    }
}
