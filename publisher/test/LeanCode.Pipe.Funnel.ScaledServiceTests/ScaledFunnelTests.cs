using System.Net.Http.Json;
using FluentAssertions;
using LeanCode.Pipe.Funnel.TestApp1;
using LeanCode.Pipe.TestClient;
using Microsoft.AspNetCore.Http.Connections;
using Xunit;

namespace LeanCode.Pipe.Funnel.ScaledServiceTests;

public class ScaledFunnelTests
{
    private readonly LeanPipeTestClient leanPipeAClient =
        new(
            new(
                "http://testapp-funnel-0.testapp-funnel-svc.default.svc.cluster.local:8080/leanpipe"
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
                "http://testapp-funnel-1.testapp-funnel-svc.default.svc.cluster.local:8080/leanpipe"
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
            BaseAddress = new("http://testapp1-0.testapp1-svc.default.svc.cluster.local:8080"),
        };

    [Fact]
    public async Task Client_receives_notifications_while_connected_to_any_Funnel_instance()
    {
        var topic = new Topic1
        {
            Topic1Id = nameof(Client_receives_notifications_while_connected_to_any_Funnel_instance),
        };

        await leanPipeAClient.SubscribeSuccessAsync(topic);
        await leanPipeBClient.SubscribeSuccessAsync(topic);

        var expectedNotification = new Notification1
        {
            Greeting = $"Hello from topic1 {topic.Topic1Id}",
        };

        var funnelANotification = leanPipeAClient.WaitForNextNotificationOn(topic);
        var funnelBNotification = leanPipeBClient.WaitForNextNotificationOn(topic);

        await testApp1Client.PostAsJsonAsync("/publish", topic);

        (await funnelANotification)
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());

        (await funnelBNotification)
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());
    }
}
