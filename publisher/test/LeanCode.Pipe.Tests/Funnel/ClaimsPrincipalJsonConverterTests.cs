using System.Security.Claims;
using System.Text.Json;
using FluentAssertions;
using LeanCode.Pipe.Funnel;
using Xunit;

namespace LeanCode.Pipe.Tests.Funnel;

public class ClaimsPrincipalJsonConverterTests
{
    private static readonly ClaimsPrincipal SampleClaimsPrincipal = new(
        new ClaimsIdentity(
            new Claim[] { new("sub", "38487af9-f46b-4daf-bc23-b69358c6c9ce"), new("role", "user") },
            "scheme",
            "sub",
            "role"
        )
    );

    private static readonly JsonSerializerOptions SerializerOptions = new()
    {
        Converters = { new ClaimsPrincipalJsonConverter() },
    };

    [Fact]
    public void ClaimsPrincipal_serializes_and_deserializes_correctly()
    {
        var serialized = JsonSerializer.Serialize(SampleClaimsPrincipal, SerializerOptions);
        var deserialized = JsonSerializer.Deserialize<ClaimsPrincipal>(
            serialized,
            SerializerOptions
        );

        deserialized
            .Should()
            .BeEquivalentTo(SampleClaimsPrincipal, opts => opts.IgnoringCyclicReferences());
    }
}
