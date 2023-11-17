using System.Net.Http.Json;
using FluentAssertions;
using LeanCode.Contracts;
using LeanCode.Pipe.IntegrationTests.App;
using LeanCode.Pipe.TestClient;

namespace LeanCode.Pipe.IntegrationTests;

public static class PublishingExtensions
{
    public const string SimpleTopicPublishEndpoint = "/publish_simple";
    public const string DynamicTopicPublishEndpoint = "/publish_dynamic";
    public const string AuthorizedTopicPublishEndpoint = "/publish_authorized";

    public static Task PublishToSimpleTopicAndAwaitNotificationAsync<TNotification>(
        this HttpClient client,
        NotificationDataDTO notificationData,
        LeanPipeTestClient leanPipeClient,
        SimpleTopic topic,
        TNotification expectedNotification
    )
        where TNotification : notnull
    {
        return PostToPublishAndCheckNotificationAsync(
            client,
            SimpleTopicPublishEndpoint,
            notificationData,
            leanPipeClient,
            topic,
            expectedNotification
        );
    }

    public static Task PublishToSimpleTopicAndAwaitNoNotificationsAsync(
        this HttpClient client,
        NotificationDataDTO notificationData
    )
    {
        return PostToPublishAndAwaitNoNotificationsAsync(
            client,
            SimpleTopicPublishEndpoint,
            notificationData
        );
    }

    public static Task PublishToDynamicTopicAndAwaitNotificationAsync<TNotification>(
        this HttpClient client,
        ProjectNotificationDataDTO notificationData,
        LeanPipeTestClient leanPipeClient,
        MyFavouriteProjectsTopic topic,
        TNotification expectedNotification
    )
        where TNotification : notnull
    {
        return PostToPublishAndCheckNotificationAsync(
            client,
            DynamicTopicPublishEndpoint,
            notificationData,
            leanPipeClient,
            topic,
            expectedNotification
        );
    }

    public static Task PublishToDynamicTopicAndAwaitNoNotificationsAsync(
        this HttpClient client,
        ProjectNotificationDataDTO notificationData
    )
    {
        return PostToPublishAndAwaitNoNotificationsAsync(
            client,
            DynamicTopicPublishEndpoint,
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
        where TNotification : notnull
    {
        return PostToPublishAndCheckNotificationAsync(
            client,
            AuthorizedTopicPublishEndpoint,
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
            AuthorizedTopicPublishEndpoint,
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
        where TNotification : notnull
    {
        var notificationTask = leanPipeClient.WaitForNextNotificationOn<TTopic, TNotification>(
            topic
        );

        await PostAndEnsureSuccessAsync(client, uri, payload).ConfigureAwait(false);

        (await notificationTask.ConfigureAwait(false))
            .Should()
            .BeEquivalentTo(expectedNotification);
    }

    private static async Task PostToPublishAndAwaitNoNotificationsAsync<TPayload>(
        HttpClient client,
        string uri,
        TPayload payload,
        TimeSpan? awaitTime = null
    )
    {
        await PostAndEnsureSuccessAsync(client, uri, payload).ConfigureAwait(false);

        await Task.Delay(awaitTime ?? TimeSpan.FromSeconds(1)).ConfigureAwait(false);
    }

    public static async Task PostAndEnsureSuccessAsync<TPayload>(
        this HttpClient client,
        string uri,
        TPayload payload
    )
    {
        using var response = await client.PostAsJsonAsync(uri, payload).ConfigureAwait(false);

        response.EnsureSuccessStatusCode();
    }
}
