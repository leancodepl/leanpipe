using System.Net.Http.Json;
using FluentAssertions;
using LeanCode.Pipe.Funnel.TestApp1;
using LeanCode.Pipe.TestClient;
using Microsoft.AspNetCore.Http.Connections;
using Xunit;

namespace LeanCode.Pipe.Funnel.ScaledFunnelTests;

public class ScaledFunnelTests : IAsyncLifetime
{
    private readonly LeanPipeTestClient leanPipeAClient =
        new(
            new(
                "http://scaled-funnel-funnel-0.scaled-funnel-funnel-svc.scaled-funnel.svc.cluster.local:8080/leanpipe"
            ),
            new(typeof(Topic1)),
            cfg =>
            {
                cfg.Transports = HttpTransportType.WebSockets;
                cfg.SkipNegotiation = true;
            }
        );

    private readonly LeanPipeTestClient leanPipeBClient =
        new(
            new(
                "http://scaled-funnel-funnel-1.scaled-funnel-funnel-svc.scaled-funnel.svc.cluster.local:8080/leanpipe"
            ),
            new(typeof(Topic1)),
            cfg =>
            {
                cfg.Transports = HttpTransportType.WebSockets;
                cfg.SkipNegotiation = true;
            }
        );

    private readonly HttpClient testApp1Client =
        new()
        {
            BaseAddress = new(
                "http://scaled-funnel-testapp1-0.scaled-funnel-testapp1-svc.scaled-funnel.svc.cluster.local:8080"
            ),
        };

    [Fact]
    public async Task Client_receives_notifications_while_connected_to_any_Funnel_instance()
    {
        var topic = new Topic1
        {
            Topic1Id = nameof(Client_receives_notifications_while_connected_to_any_Funnel_instance),
        };

        await leanPipeAClient.SubscribeSuccessAsync(topic).ConfigureAwait(false);
        await leanPipeBClient.SubscribeSuccessAsync(topic).ConfigureAwait(false);

        var expectedNotification = new Notification1
        {
            Greeting = $"Hello from topic1 {topic.Topic1Id}",
        };

        var funnelANotification = leanPipeAClient.WaitForNextNotificationOn(topic);
        var funnelBNotification = leanPipeBClient.WaitForNextNotificationOn(topic);

        await testApp1Client.PostAsJsonAsync("/publish", topic).ConfigureAwait(false);

        (await funnelANotification.ConfigureAwait(false))
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());

        (await funnelBNotification.ConfigureAwait(false))
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());

        await leanPipeAClient.UnsubscribeSuccessAsync(topic).ConfigureAwait(false);
        await leanPipeBClient.UnsubscribeSuccessAsync(topic).ConfigureAwait(false);
    }

    public Task InitializeAsync() => Task.CompletedTask;

    public async Task DisposeAsync()
    {
        await leanPipeAClient.DisposeAsync().ConfigureAwait(false);
        await leanPipeBClient.DisposeAsync().ConfigureAwait(false);
        testApp1Client.Dispose();
    }
}
