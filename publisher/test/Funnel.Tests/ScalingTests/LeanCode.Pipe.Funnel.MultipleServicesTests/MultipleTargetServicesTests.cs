using System.Net.Http.Json;
using LeanCode.Pipe.Funnel.TestApp1;
using LeanCode.Pipe.Funnel.TestApp2;
using LeanCode.Pipe.TestClient;
using Microsoft.AspNetCore.Http.Connections;

namespace LeanCode.Pipe.Funnel.MultipleServicesTests;

public class MultipleTargetServicesTests : IAsyncLifetime
{
    private readonly LeanPipeTestClient leanPipeClient = new(
        new(
            "http://multiple-services-funnel-0.multiple-services-funnel-svc.multiple-services.svc.cluster.local:8080/leanpipe"
        ),
        new(typeof(Topic1), typeof(Topic2)),
        cfg =>
        {
            cfg.Transports = HttpTransportType.WebSockets;
            cfg.SkipNegotiation = true;
        }
    );

    private readonly HttpClient testApp1Client = new()
    {
        BaseAddress = new(
            "http://multiple-services-testapp1-0.multiple-services-testapp1-svc.multiple-services.svc.cluster.local:8080"
        ),
    };

    private readonly HttpClient testApp2Client = new()
    {
        BaseAddress = new(
            "http://multiple-services-testapp2-0.multiple-services-testapp2-svc.multiple-services.svc.cluster.local:8080"
        ),
    };

    [Fact(Explicit = true)]
    public async Task Subscribing_and_receiving_notifications_from_any_target_service_works_and_does_not_interfere_with_each_other()
    {
        var topic1 = new Topic1
        {
            Topic1Id = nameof(
                Subscribing_and_receiving_notifications_from_any_target_service_works_and_does_not_interfere_with_each_other
            ),
        };

        var topic2 = new Topic2
        {
            Topic2Id = nameof(
                Subscribing_and_receiving_notifications_from_any_target_service_works_and_does_not_interfere_with_each_other
            ),
        };

        var expectedNotification1 = new Notification1
        {
            Greeting = $"Hello from topic1 {topic1.Topic1Id}",
        };

        var expectedNotification2 = new Notification2
        {
            Farewell = $"Goodbye from topic2 {topic2.Topic2Id}",
        };

        await leanPipeClient.SubscribeSuccessAsync(topic1, TestContext.Current.CancellationToken);
        await leanPipeClient.SubscribeSuccessAsync(topic2, TestContext.Current.CancellationToken);

        await NotificationsAreReceivedOnlyOnThePublishedTopics();

        await leanPipeClient.UnsubscribeSuccessAsync(topic1, TestContext.Current.CancellationToken);

        await NotificationsAreNotReceivedOnTheUnsubscribedTopic();
        await NotificationsAreStillReceivedOnTheOtherSubscribedTopic();

        await leanPipeClient.UnsubscribeSuccessAsync(topic2, TestContext.Current.CancellationToken);

        async Task NotificationsAreReceivedOnlyOnThePublishedTopics()
        {
            var service1Notification = leanPipeClient.WaitForNextNotificationOn(
                topic1,
                ct: TestContext.Current.CancellationToken
            );
            var service2Notification = leanPipeClient.WaitForNextNotificationOn(
                topic2,
                timeout: TimeSpan.FromMilliseconds(500),
                ct: TestContext.Current.CancellationToken
            );

            await testApp1Client.PostAsJsonAsync(
                "/publish",
                topic1,
                TestContext.Current.CancellationToken
            );

            (await service1Notification)
                .Should()
                .BeEquivalentTo(expectedNotification1, opts => opts.RespectingRuntimeTypes());

            await service2Notification
                .Awaiting(x => x)
                .Should()
                .ThrowAsync<OperationCanceledException>();

            service2Notification = leanPipeClient.WaitForNextNotificationOn(
                topic2,
                ct: TestContext.Current.CancellationToken
            );
            service1Notification = leanPipeClient.WaitForNextNotificationOn(
                topic1,
                timeout: TimeSpan.FromMilliseconds(500),
                ct: TestContext.Current.CancellationToken
            );

            await testApp2Client.PostAsJsonAsync(
                "/publish",
                topic2,
                TestContext.Current.CancellationToken
            );

            (await service2Notification)
                .Should()
                .BeEquivalentTo(expectedNotification2, opts => opts.RespectingRuntimeTypes());

            await service1Notification
                .Awaiting(x => x)
                .Should()
                .ThrowAsync<OperationCanceledException>();
        }

        async Task NotificationsAreNotReceivedOnTheUnsubscribedTopic()
        {
            var service1Notification = leanPipeClient.WaitForNextNotificationOn(
                topic1,
                timeout: TimeSpan.FromMilliseconds(500),
                ct: TestContext.Current.CancellationToken
            );

            await testApp1Client.PostAsJsonAsync(
                "/publish",
                topic1,
                TestContext.Current.CancellationToken
            );

            await service1Notification
                .Awaiting(x => x)
                .Should()
                .ThrowAsync<OperationCanceledException>();
        }

        async Task NotificationsAreStillReceivedOnTheOtherSubscribedTopic()
        {
            var service2Notification = leanPipeClient.WaitForNextNotificationOn(
                topic2,
                ct: TestContext.Current.CancellationToken
            );

            await testApp2Client.PostAsJsonAsync(
                "/publish",
                topic2,
                TestContext.Current.CancellationToken
            );

            (await service2Notification)
                .Should()
                .BeEquivalentTo(expectedNotification2, opts => opts.RespectingRuntimeTypes());
        }
    }

    public ValueTask InitializeAsync() => ValueTask.CompletedTask;

    public async ValueTask DisposeAsync()
    {
        await leanPipeClient.DisposeAsync();
        testApp1Client.Dispose();
        testApp2Client.Dispose();
        GC.SuppressFinalize(this);
    }
}
