namespace LeanCode.Pipe.IntegrationTests.App;

public class NotificationDataDTO
{
    public Guid TopicId { get; set; }
    public string Name { get; set; } = default!;
    public NotificationKindDTO Kind { get; set; }
}

public enum NotificationKindDTO
{
    Greeting = 1,
    Farewell = 2,
}

public class ProjectNotificationDataDTO
{
    public Guid ProjectId { get; set; }
    public ProjectNotificationKindDTO Kind { get; set; }
}

public enum ProjectNotificationKindDTO
{
    Updated = 1,
    Deleted = 2,
}
