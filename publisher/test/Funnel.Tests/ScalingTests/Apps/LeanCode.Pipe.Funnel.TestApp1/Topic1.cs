using LeanCode.Contracts;
using LeanCode.Contracts.Security;

namespace LeanCode.Pipe.Funnel.TestApp1;

[AllowUnauthorized]
public class Topic1 : ITopic, IProduceNotification<Notification1>
{
    public string Topic1Id { get; set; } = default!;
}

public class Notification1
{
    public string Greeting { get; set; } = default!;
}

public class Topic1Keys : BasicTopicKeys<Topic1, Notification1>
{
    public override IEnumerable<string> Get(Topic1 topic) => new[] { $"topic1_{topic.Topic1Id}" };
}
