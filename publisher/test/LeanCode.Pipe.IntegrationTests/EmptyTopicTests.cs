using FluentAssertions;
using LeanCode.Contracts;
using LeanCode.Pipe.IntegrationTests.App;
using LeanCode.Pipe.TestClient;
using Xunit;

namespace LeanCode.Pipe.IntegrationTests;

public class EmptyTopicTests : TestApplicationFactory
{
    private readonly LeanPipeTestClient leanPipeClient;

    public EmptyTopicTests()
    {
        leanPipeClient = CreateLeanPipeTestClient(AuthenticatedAs.NotAuthenticated);
    }

    [Fact]
    public async Task Subscribing_to_topic_with_no_keys_returns_invalid_result()
    {
        var topic = new EmptyTopic();

        var result = await leanPipeClient.SubscribeAsync(
            topic,
            TestContext.Current.CancellationToken
        );
        result.Should().BeEquivalentTo(new { Status = SubscriptionStatus.Invalid });
    }
}
