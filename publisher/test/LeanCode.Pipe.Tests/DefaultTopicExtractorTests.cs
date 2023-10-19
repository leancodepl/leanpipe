using FluentAssertions;
using LeanCode.Components;
using LeanCode.Pipe.Tests.Additional;
using Xunit;

namespace LeanCode.Pipe.Tests;

public class DefaultTopicExtractorTests
{
    private static readonly TypesCatalog ThisCatalog =
        TypesCatalog.Of<LeanPipeServiceCollectionExtensionsTests>();

    [Fact]
    public void Extracts_topics_from_types_catalog()
    {
        var extractor = new DefaultTopicExtractor(ThisCatalog, null);

        extractor.Extract(Envelope.Empty<Topic1>()).Should().NotBeNull().And.BeOfType<Topic1>();
        extractor.Extract(Envelope.Empty<Topic2>()).Should().NotBeNull().And.BeOfType<Topic2>();
    }

    [Fact]
    public void If_type_is_not_valid_type_It_wont_be_extracted()
    {
        var extractor = new DefaultTopicExtractor(ThisCatalog, null);

        extractor.Extract(Envelope.Empty<AbstractTopic>()).Should().BeNull();
        extractor.Extract(Envelope.Empty<GenericTopic<int>>()).Should().BeNull();
    }

    [Fact]
    public void If_type_is_not_in_the_catalog_It_wont_be_extracted()
    {
        var extractor = new DefaultTopicExtractor(ThisCatalog, null);

        extractor.Extract(Envelope.Empty<ExternalTopic>()).Should().BeNull();
    }

    [Fact]
    public void Extracts_type_from_external_assemblies_if_they_are_in_the_catalog()
    {
        var extractor = new DefaultTopicExtractor(
            ThisCatalog.Merge(TypesCatalog.Of<ExternalTopic>()),
            null
        );

        extractor
            .Extract(Envelope.Empty<ExternalTopic>())
            .Should()
            .NotBeNull()
            .And.BeOfType<ExternalTopic>();
    }
}
