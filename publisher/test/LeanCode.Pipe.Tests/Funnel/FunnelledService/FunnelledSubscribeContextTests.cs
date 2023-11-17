using System.Collections.Immutable;
using FluentAssertions;
using LeanCode.Pipe.Funnel.FunnelledService;
using Xunit;

namespace LeanCode.Pipe.Tests.Funnel.FunnelledService;

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
        await context.AddToGroupsAsync(SampleGroupKeys, default).ConfigureAwait(false);

        context.GroupKeys.Should().BeEquivalentTo(SampleGroupKeys);
    }

    [Fact]
    public async Task FunnelledSubscribeContext_allows_retrieving_keys_after_removing_from_group()
    {
        await context.RemoveFromGroupsAsync(SampleGroupKeys, default).ConfigureAwait(false);

        context.GroupKeys.Should().BeEquivalentTo(SampleGroupKeys);
    }
}
