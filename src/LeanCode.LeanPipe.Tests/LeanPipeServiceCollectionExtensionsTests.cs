using LeanCode.Components;
using LeanCode.Contracts;
using LeanCode.LeanPipe.Extensions;
using LeanCode.LeanPipe.Tests.Additional;
using Microsoft.Extensions.DependencyInjection;
using Xunit;

namespace LeanCode.LeanPipe.Tests;

public class LeanPipeServiceCollectionExtensionsTests
{
    private static readonly TypesCatalog ThisCatalog =
        TypesCatalog.Of<LeanPipeServiceCollectionExtensionsTests>();

    [Fact]
    public void Registers_all_basic_types()
    {
        var collection = new ServiceCollection();
        collection.AddLeanPipe(ThisCatalog, ThisCatalog);

        Assert.Single(collection, d => d.ServiceType == typeof(IEnvelopeDeserializer));
        Assert.Single(collection, d => d.ServiceType == typeof(SubscriptionHandlerResolver));
        Assert.Single(collection, d => d.ServiceType == typeof(LeanPipePublisher<>));
        Assert.Single(collection, d => d.ServiceType == typeof(ISubscriptionHandler<>));
    }

    [Fact]
    public void Updates_deserializer_when_registering_additional_types()
    {
        var collection = new ServiceCollection();
        collection
            .AddLeanPipe(ThisCatalog, ThisCatalog)
            .AddTopics(TypesCatalog.Of<ExternalTopic>());

        var deserializer = collection
            .BuildServiceProvider()
            .GetRequiredService<IEnvelopeDeserializer>();
        var topic = deserializer.Deserialize(
            new()
            {
                Id = Guid.NewGuid(),
                Topic = "{}",
                TopicType = typeof(ExternalTopic).FullName!
            }
        );

        Assert.NotNull(topic);
        Assert.IsType<ExternalTopic>(topic);
    }
}

public abstract class AbstractTopic : ITopic { }

public class GenericTopic<T> : ITopic { }

public class Topic1 : ITopic { }

public class Topic2 : AbstractTopic { }
