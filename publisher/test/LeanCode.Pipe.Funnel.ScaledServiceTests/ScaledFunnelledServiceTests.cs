using System.Net.Http.Json;
using FluentAssertions;
using LeanCode.Pipe.Funnel.TestApp1;
using LeanCode.Pipe.TestClient;
using Microsoft.AspNetCore.Http.Connections;
using Xunit;

namespace LeanCode.Pipe.Funnel.ScaledServiceTests;

public class ScaledFunnelledServiceTests
{
    private readonly LeanPipeTestClient leanPipeClient =
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

    private readonly HttpClient testApp1AClient =
        new()
        {
            BaseAddress = new("http://testapp1-0.testapp1-svc.default.svc.cluster.local:8080"),
        };

    private readonly HttpClient testApp1BClient =
        new()
        {
            BaseAddress = new("http://testapp1-1.testapp1-svc.default.svc.cluster.local:8080"),
        };

    [Fact]
    public async Task Publishing_notifications_from_any_service_instance_works()
    {
        var topic = new Topic1
        {
            Topic1Id = nameof(Publishing_notifications_from_any_service_instance_works),
        };

        await leanPipeClient.SubscribeSuccessAsync(topic);

        var expectedNotification = new Notification1
        {
            Greeting = $"Hello from topic1 {topic.Topic1Id}",
        };

        var instanceANotification = leanPipeClient.WaitForNextNotificationOn(topic);

        await testApp1AClient.PostAsJsonAsync("/publish", topic);

        (await instanceANotification)
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());

        var instanceBNotification = leanPipeClient.WaitForNextNotificationOn(topic);

        await testApp1BClient.PostAsJsonAsync("/publish", topic);

        (await instanceBNotification)
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());
    }
}
