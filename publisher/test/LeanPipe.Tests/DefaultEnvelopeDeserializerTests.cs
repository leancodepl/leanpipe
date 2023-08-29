using FluentAssertions;
using LeanCode.Components;
using LeanPipe.Tests.Additional;
using Xunit;

namespace LeanPipe.Tests;

public class DefaultEnvelopeDeserializerTests
{
    private static readonly TypesCatalog ThisCatalog =
        TypesCatalog.Of<LeanPipeServiceCollectionExtensionsTests>();

    [Fact]
    public void Deserializes_types_from_catalog()
    {
        var deserializer = new DefaultEnvelopeDeserializer(ThisCatalog, null);

        deserializer
            .Deserialize(Envelope.Empty<Topic1>())
            .Should()
            .NotBeNull()
            .And.BeOfType<Topic1>();
        deserializer
            .Deserialize(Envelope.Empty<Topic2>())
            .Should()
            .NotBeNull()
            .And.BeOfType<Topic2>();
    }

    [Fact]
    public void If_type_is_not_valid_type_It_wont_be_deserialized()
    {
        var deserializer = new DefaultEnvelopeDeserializer(ThisCatalog, null);

        deserializer.Deserialize(Envelope.Empty<AbstractTopic>()).Should().BeNull();
        deserializer.Deserialize(Envelope.Empty<GenericTopic<int>>()).Should().BeNull();
    }

    [Fact]
    public void If_type_is_not_in_the_catalog_It_wont_be_deserialized()
    {
        var deserializer = new DefaultEnvelopeDeserializer(ThisCatalog, null);

        deserializer.Deserialize(Envelope.Empty<ExternalTopic>()).Should().BeNull();
    }

    [Fact]
    public void Deserializes_type_from_external_assemblies_if_they_are_in_the_catalog()
    {
        var deserializer = new DefaultEnvelopeDeserializer(
            ThisCatalog.Merge(TypesCatalog.Of<ExternalTopic>()),
            null
        );

        deserializer
            .Deserialize(Envelope.Empty<ExternalTopic>())
            .Should()
            .NotBeNull()
            .And.BeOfType<ExternalTopic>();
    }
}
