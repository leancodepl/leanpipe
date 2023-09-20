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
