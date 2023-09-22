namespace LeanCode.Pipe.IntegrationTests.App;

public class SimpleTopicKeys
    : BasicTopicKeys<SimpleTopic, GreetingNotificationDTO, FarewellNotificationDTO>
{
    public override IEnumerable<string> Get(SimpleTopic topic) =>
        new[] { $"simple_{topic.TopicId.ToString()}" };
}

public class AuthorizedTopicKeys
    : BasicTopicKeys<AuthorizedTopic, GreetingNotificationDTO, FarewellNotificationDTO>
{
    public override IEnumerable<string> Get(AuthorizedTopic topic) =>
        new[] { $"authorized_{topic.TopicId.ToString()}" };
}

public class EmptyTopicKeys : BasicTopicKeys<EmptyTopic>
{
    public override IEnumerable<string> Get(EmptyTopic topic) => new List<string>();
}
