using LeanCode.Contracts;
using LeanCode.Contracts.Security;

namespace LeanCode.Pipe.Funnel.TestApp2;

[AllowUnauthorized]
public class Topic2 : ITopic, IProduceNotification<Notification2>
{
    public string Topic2Id { get; set; } = default!;
}

public class Notification2
{
    public string Farewell { get; set; } = default!;
}

public class Topic2Keys : BasicTopicKeys<Topic2, Notification2>
{
    public override IEnumerable<string> Get(Topic2 topic) => new[] { $"topic2_{topic.Topic2Id}" };
}
