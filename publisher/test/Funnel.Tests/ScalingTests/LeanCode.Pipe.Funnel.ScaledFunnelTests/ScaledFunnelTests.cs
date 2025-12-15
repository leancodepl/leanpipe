using System.Net.Http.Json;
using LeanCode.Pipe.Funnel.TestApp1;
using LeanCode.Pipe.TestClient;
using Microsoft.AspNetCore.Http.Connections;

namespace LeanCode.Pipe.Funnel.ScaledFunnelTests;

public class ScaledFunnelTests : IAsyncLifetime
{
    private readonly LeanPipeTestClient leanPipeAClient = new(
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

    private readonly LeanPipeTestClient leanPipeBClient = new(
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

    private readonly HttpClient testApp1Client = new()
    {
        BaseAddress = new(
            "http://scaled-funnel-testapp1-0.scaled-funnel-testapp1-svc.scaled-funnel.svc.cluster.local:8080"
        ),
    };

    [Fact(Explicit = true)]
    public async Task Client_receives_notifications_while_connected_to_any_Funnel_instance()
    {
        var topic = new Topic1
        {
            Topic1Id = nameof(Client_receives_notifications_while_connected_to_any_Funnel_instance),
        };

        await leanPipeAClient.SubscribeSuccessAsync(topic, TestContext.Current.CancellationToken);
        await leanPipeBClient.SubscribeSuccessAsync(topic, TestContext.Current.CancellationToken);

        var expectedNotification = new Notification1
        {
            Greeting = $"Hello from topic1 {topic.Topic1Id}",
        };

        var funnelANotification = leanPipeAClient.WaitForNextNotificationOn(
            topic,
            ct: TestContext.Current.CancellationToken
        );
        var funnelBNotification = leanPipeBClient.WaitForNextNotificationOn(
            topic,
            ct: TestContext.Current.CancellationToken
        );

        await testApp1Client.PostAsJsonAsync(
            "/publish",
            topic,
            TestContext.Current.CancellationToken
        );

        (await funnelANotification)
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());

        (await funnelBNotification)
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());

        await leanPipeAClient.UnsubscribeSuccessAsync(topic, TestContext.Current.CancellationToken);
        await leanPipeBClient.UnsubscribeSuccessAsync(topic, TestContext.Current.CancellationToken);
    }

    public ValueTask InitializeAsync() => ValueTask.CompletedTask;

    public async ValueTask DisposeAsync()
    {
        await leanPipeAClient.DisposeAsync();
        await leanPipeBClient.DisposeAsync();
        testApp1Client.Dispose();
        GC.SuppressFinalize(this);
    }
}
