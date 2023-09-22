using LeanCode.Contracts;

namespace LeanCode.Pipe.IntegrationTests.App;

public static class ApiHandlers
{
    public static async Task PublishGreetingOrFarewellAsync<TTopic>(
        LeanPipePublisher<TTopic> publisher,
        TTopic topic,
        NotificationDataDTO notificationData,
        CancellationToken ct
    )
        where TTopic : ITopic,
            IProduceNotification<GreetingNotificationDTO>,
            IProduceNotification<FarewellNotificationDTO>
    {
        switch (notificationData.Kind)
        {
            case NotificationKindDTO.Greeting:
                await publisher.PublishAsync(topic, CreateGreeting(notificationData), ct);
                break;
            case NotificationKindDTO.Farewell:
                await publisher.PublishAsync(topic, CreateFarewell(notificationData), ct);
                break;
            default:
                throw new InvalidOperationException(
                    $"Invalid notification kind {notificationData.Kind}"
                );
        }
    }

    public static async Task PublishProjectUpdatedOrDeletedAsync(
        LeanPipePublisher<MyFavouriteProjectsTopic> publisher,
        MyFavouriteProjectsTopic topic,
        ProjectNotificationDataDTO projectNotificationData,
        CancellationToken ct
    )
    {
        switch (projectNotificationData.Kind)
        {
            case ProjectNotificationKindDTO.Updated:
                await publisher.PublishAsync(
                    topic,
                    CreateProjectUpdated(projectNotificationData),
                    ct
                );
                break;
            case ProjectNotificationKindDTO.Deleted:
                await publisher.PublishAsync(
                    topic,
                    CreateProjectDeleted(projectNotificationData),
                    ct
                );
                break;
            default:
                throw new InvalidOperationException(
                    $"Invalid project notification kind {projectNotificationData.Kind}"
                );
        }
    }

    private static GreetingNotificationDTO CreateGreeting(NotificationDataDTO notificationData) =>
        new() { Greeting = $"Hello {notificationData.Name}" };

    private static FarewellNotificationDTO CreateFarewell(NotificationDataDTO notificationData) =>
        new() { Farewell = $"Goodbye {notificationData.Name}" };

    private static ProjectUpdatedNotificationDTO CreateProjectUpdated(
        ProjectNotificationDataDTO notificationData
    ) => new() { ProjectId = notificationData.ProjectId };

    private static ProjectDeletedNotificationDTO CreateProjectDeleted(
        ProjectNotificationDataDTO notificationData
    ) => new() { ProjectId = notificationData.ProjectId };
}
