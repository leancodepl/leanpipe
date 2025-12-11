using System.Collections.Immutable;
using FluentAssertions;
using LeanCode.Pipe.Funnel.Publishing;
using Xunit;

namespace LeanCode.Pipe.Funnel.Tests.Publishing;

public class FunnelledSubscribeContextTests
{
    private static readonly ImmutableArray<string> SampleGroupKeys = new[]
    {
        "key1",
        "key2",
    }.ToImmutableArray();

    private readonly FunnelledSubscribeContext context = new();

    [Fact]
    public async Task FunnelledSubscribeContext_allows_retrieving_keys_after_adding_to_group()
    {
        await context.AddToGroupsAsync(SampleGroupKeys, default);

        context.GroupKeys.Should().BeEquivalentTo(SampleGroupKeys);
    }

    [Fact]
    public async Task FunnelledSubscribeContext_allows_retrieving_keys_after_removing_from_group()
    {
        await context.RemoveFromGroupsAsync(SampleGroupKeys, default);

        context.GroupKeys.Should().BeEquivalentTo(SampleGroupKeys);
    }
}
