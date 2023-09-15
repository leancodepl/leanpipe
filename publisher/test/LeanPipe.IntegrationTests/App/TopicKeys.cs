namespace LeanPipe.IntegrationTests.App;

public class BasicTopicKeys : BasicTopicKeys<BasicTopic>
{
    public override IEnumerable<string> Get(BasicTopic topic) =>
        new[] { topic.TopicId.ToString() };
}

public class AuthorizedTopicKeys : BasicTopicKeys<AuthorizedTopic>
{
    public override IEnumerable<string> Get(AuthorizedTopic topic) =>
        new[] { topic.TopicId.ToString() };
}
