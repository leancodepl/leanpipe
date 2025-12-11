namespace LeanCode.Pipe.IntegrationTests.App;

public class SimpleTopicKeys
    : BasicTopicKeys<SimpleTopic, GreetingNotificationDTO, FarewellNotificationDTO>
{
    public override IEnumerable<string> Get(SimpleTopic topic) =>
        [$"simple_{topic.TopicId.ToString()}"];
}

public class MyFavouriteProjectsTopicKeys
    : IPublishingKeys<MyFavouriteProjectsTopic, ProjectUpdatedNotificationDTO>,
        IPublishingKeys<MyFavouriteProjectsTopic, ProjectDeletedNotificationDTO>
{
    private readonly FavouriteProjectsProvider favouriteProjectsProvider;

    public MyFavouriteProjectsTopicKeys()
    {
        favouriteProjectsProvider = new();
    }

    public async ValueTask<IEnumerable<string>> GetForSubscribingAsync(
        MyFavouriteProjectsTopic topic,
        LeanPipeContext context
    ) =>
        (await favouriteProjectsProvider.GetUsersFavouriteProjectsAsync(context.User)).Select(
            ToTopicKey
        );

    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        MyFavouriteProjectsTopic topic,
        ProjectUpdatedNotificationDTO notification,
        CancellationToken ct = default
    ) => ValueTask.FromResult((IEnumerable<string>)[ToTopicKey(notification.ProjectId)]);

    public ValueTask<IEnumerable<string>> GetForPublishingAsync(
        MyFavouriteProjectsTopic topic,
        ProjectDeletedNotificationDTO notification,
        CancellationToken ct = default
    ) => ValueTask.FromResult((IEnumerable<string>)[ToTopicKey(notification.ProjectId)]);

    private static string ToTopicKey(Guid projectId) => $"favouriteproject_{projectId}";
}

public class AuthorizedTopicKeys
    : BasicTopicKeys<AuthorizedTopic, GreetingNotificationDTO, FarewellNotificationDTO>
{
    public override IEnumerable<string> Get(AuthorizedTopic topic) =>
        [$"authorized_{topic.TopicId.ToString()}"];
}

public class EmptyTopicKeys : BasicTopicKeys<EmptyTopic>
{
    public override IEnumerable<string> Get(EmptyTopic topic) => new List<string>();
}
