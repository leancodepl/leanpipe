namespace LeanPipe.IntegrationTests.App;

public class UnauthorizedTopicKeys : BasicTopicKeys<UnauthorizedTopic>
{
    public override IEnumerable<string> Get(UnauthorizedTopic topic) =>
        new[] { topic.TopicId.ToString() };
}

public class AuthorizedTopicKeys : BasicTopicKeys<AuthorizedTopic>
{
    public override IEnumerable<string> Get(AuthorizedTopic topic) =>
        new[] { topic.TopicId.ToString() };
}
