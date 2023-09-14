using System.Net.Http.Json;
using FluentAssertions;
using LeanCode.Contracts;
using LeanPipe.IntegrationTests.App;
using LeanPipe.TestClient;

namespace LeanPipe.IntegrationTests;

public static class PublishingExtensions
{
    public static Task PublishToUnauthorizedTopicAndAwaitNotificationAsync<TNotification>(
        this HttpClient client,
        NotificationDataDTO notificationData,
        LeanPipeTestClient leanPipeClient,
        UnauthorizedTopic topic,
        TNotification expectedNotification
    )
    {
        return PostToPublishAndCheckNotificationAsync(
            client,
            "/publish_unauthorized",
            notificationData,
            leanPipeClient,
            topic,
            expectedNotification
        );
    }

    public static Task PublishToUnauthorizedTopicAndAwaitNoNotificationsAsync(
        this HttpClient client,
        NotificationDataDTO notificationData
    )
    {
        return PostToPublishAndAwaitNoNotificationsAsync(
            client,
            "/publish_unauthorized",
            notificationData
        );
    }

    public static Task PublishToAuthorizedTopicAndAwaitNotificationAsync<TNotification>(
        this HttpClient client,
        NotificationDataDTO notificationData,
        LeanPipeTestClient leanPipeClient,
        UnauthorizedTopic topic,
        TNotification expectedNotification
    )
    {
        return PostToPublishAndCheckNotificationAsync(
            client,
            "/publish_authorized",
            notificationData,
            leanPipeClient,
            topic,
            expectedNotification
        );
    }

    public static Task PublishToAuthorizedTopicAndAwaitNoNotificationsAsync(
        this HttpClient client,
        NotificationDataDTO notificationData
    )
    {
        return PostToPublishAndAwaitNoNotificationsAsync(
            client,
            "/publish_authorized",
            notificationData
        );
    }

    private static async Task PostToPublishAndCheckNotificationAsync<
        TPayload,
        TTopic,
        TNotification
    >(
        HttpClient client,
        string uri,
        TPayload payload,
        LeanPipeTestClient leanPipeClient,
        TTopic topic,
        TNotification expectedNotification
    )
        where TTopic : ITopic
    {
        var notificationTask = leanPipeClient.GetNextNotificationTaskOn(topic);

        await PostAsync(client, uri, payload);

        (await notificationTask)
            .Should()
            .BeEquivalentTo(expectedNotification, opts => opts.RespectingRuntimeTypes());
    }

    private static async Task PostToPublishAndAwaitNoNotificationsAsync<TPayload>(
        HttpClient client,
        string uri,
        TPayload payload,
        TimeSpan? awaitTime = null
    )
    {
        await PostAsync(client, uri, payload);

        await Task.Delay(awaitTime ?? TimeSpan.FromSeconds(1));
    }

    private static async Task PostAsync<TPayload>(HttpClient client, string uri, TPayload payload)
    {
        using var response = await client.PostAsJsonAsync(uri, payload);

        response.EnsureSuccessStatusCode();
    }
}
