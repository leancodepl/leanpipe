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

    private static GreetingNotificationDTO CreateGreeting(NotificationDataDTO notificationData) =>
        new() { Greeting = $"Hello {notificationData.Name}" };

    private static FarewellNotificationDTO CreateFarewell(NotificationDataDTO notificationData) =>
        new() { Farewell = $"Goodbye {notificationData.Name}" };
}
