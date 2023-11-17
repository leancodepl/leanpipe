using LeanCode.Pipe.ClientIntegrationTestsApp.Contracts;

namespace LeanCode.Pipe.ClientIntegrationTestsApp;

public class TopicKeys : BasicTopicKeys<Topic, NotificationDTO>
{
    public override IEnumerable<string> Get(Topic topic) => new[] { topic.TopicId };
}
