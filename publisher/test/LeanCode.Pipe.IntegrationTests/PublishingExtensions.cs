using System.Net.Http.Json;
using FluentAssertions;
using LeanCode.Contracts;
using LeanCode.Pipe.IntegrationTests.App;
using LeanCode.Pipe.TestClient;

namespace LeanCode.Pipe.IntegrationTests;

public static class PublishingExtensions
{
    public static Task PublishToBasicTopicAndAwaitNotificationAsync<TNotification>(
        this HttpClient client,
        NotificationDataDTO notificationData,
        LeanPipeTestClient leanPipeClient,
        BasicTopic topic,
        TNotification expectedNotification
    )
    {
        return PostToPublishAndCheckNotificationAsync(
            client,
            "/publish_basic",
            notificationData,
            leanPipeClient,
            topic,
            expectedNotification
        );
    }

    public static Task PublishToBasicTopicAndAwaitNoNotificationsAsync(
        this HttpClient client,
        NotificationDataDTO notificationData
    )
    {
        return PostToPublishAndAwaitNoNotificationsAsync(
            client,
            "/publish_basic",
            notificationData
        );
    }

    public static Task PublishToAuthorizedTopicAndAwaitNotificationAsync<TNotification>(
        this HttpClient client,
        NotificationDataDTO notificationData,
        LeanPipeTestClient leanPipeClient,
        AuthorizedTopic topic,
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
        var notificationTask = leanPipeClient.WaitForNextNotificationOn(topic);

        await PostAsync(client, uri, payload);

        (await notificationTask)
            .Should()
            .BeOfType<TNotification>()
            .And.BeEquivalentTo(expectedNotification);
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
