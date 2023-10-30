using LeanCode.Contracts;

namespace LeanCode.Pipe.ClientIntegrationTestsApp;

public class Topic : ITopic, IProduceNotification<NotificationDTO>
{
    public string TopicId { get; set; } = default!;
}

public class NotificationDTO
{
    public string Greeting { get; set; } = default!;
}

public class TopicKeys : BasicTopicKeys<Topic, NotificationDTO>
{
    public override IEnumerable<string> Get(Topic topic) => new[] { topic.TopicId };
}
