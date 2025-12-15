using System.Net.Http.Json;
using LeanCode.Pipe.Funnel.TestApp1;
using LeanCode.Pipe.TestClient;
using Microsoft.AspNetCore.Http.Connections;

namespace LeanCode.Pipe.Funnel.NoScalingTests;

public class NoScalingTests : IAsyncLifetime
{
    private readonly LeanPipeTestClient leanPipeClient = new(
        new(
            "http://no-scaling-funnel-0.no-scaling-funnel-svc.no-scaling.svc.cluster.local:8080/leanpipe"
        ),
        new(typeof(Topic1)),
        cfg =>
        {
            cfg.Transports = HttpTransportType.WebSockets;
            cfg.SkipNegotiation = true;
        }
    );

    private readonly HttpClient testApp1Client = new()
    {
        BaseAddress = new(
            "http://no-scaling-testapp1-0.no-scaling-testapp1-svc.no-scaling.svc.cluster.local:8080"
        ),
    };

    [Fact(Explicit = true)]
    public async Task Subscribing_and_receiving_notifications_works()
    {
        var topic = new Topic1 { Topic1Id = nameof(Subscribing_and_receiving_notifications_works) };

        await leanPipeClient.SubscribeSuccessAsync(topic, TestContext.Current.CancellationToken);

        var expectedNotification = new Notification1
        {
            Greeting = $"Hello from topic1 {topic.Topic1Id}",
        };

        var notification = leanPipeClient.WaitForNextNotificationOn(
            topic,
            ct: TestContext.Current.CancellationToken
        );

        await testApp1Client.PostAsJsonAsync(
            "/publish",
            topic,
            TestContext.Current.CancellationToken
        );

        (await notification)
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());

        var instanceBNotification = leanPipeClient.WaitForNextNotificationOn(
            topic,
            ct: TestContext.Current.CancellationToken
        );

        await leanPipeClient.UnsubscribeSuccessAsync(topic, TestContext.Current.CancellationToken);
    }

    public ValueTask InitializeAsync() => ValueTask.CompletedTask;

    public async ValueTask DisposeAsync()
    {
        await leanPipeClient.DisposeAsync();
        testApp1Client.Dispose();
        GC.SuppressFinalize(this);
    }
}
