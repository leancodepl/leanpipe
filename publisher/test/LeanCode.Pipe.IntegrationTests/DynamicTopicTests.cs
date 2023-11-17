using FluentAssertions;
using LeanCode.Pipe.IntegrationTests.App;
using LeanCode.Pipe.TestClient;
using Xunit;

namespace LeanCode.Pipe.IntegrationTests;

public class DynamicTopicTests : TestApplicationFactory
{
    private readonly HttpClient httpClient;
    private readonly LeanPipeTestClient leanPipeClient;

    public DynamicTopicTests()
    {
        httpClient = CreateClient();
        leanPipeClient = CreateLeanPipeTestClient(AuthenticatedAs.User);
    }

    [Fact]
    public async Task Subscriber_receives_only_relevant_notifications()
    {
        var topic = new MyFavouriteProjectsTopic();

        await leanPipeClient.SubscribeSuccessAsync(topic).ConfigureAwait(false);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        await httpClient
            .PublishToDynamicTopicAndAwaitNotificationAsync(
                new()
                {
                    ProjectId = FavouriteProjectsProvider.FavouriteProjectId1,
                    Kind = ProjectNotificationKindDTO.Updated,
                },
                leanPipeClient,
                topic,
                new ProjectUpdatedNotificationDTO
                {
                    ProjectId = FavouriteProjectsProvider.FavouriteProjectId1,
                }
            )
            .ConfigureAwait(false);

        await httpClient
            .PublishToDynamicTopicAndAwaitNotificationAsync(
                new()
                {
                    ProjectId = FavouriteProjectsProvider.FavouriteProjectId2,
                    Kind = ProjectNotificationKindDTO.Deleted,
                },
                leanPipeClient,
                topic,
                new ProjectDeletedNotificationDTO
                {
                    ProjectId = FavouriteProjectsProvider.FavouriteProjectId2,
                }
            )
            .ConfigureAwait(false);

        await httpClient
            .PublishToDynamicTopicAndAwaitNoNotificationsAsync(
                new() { ProjectId = Guid.NewGuid(), Kind = ProjectNotificationKindDTO.Updated, }
            )
            .ConfigureAwait(false);

        await leanPipeClient.UnsubscribeSuccessAsync(topic).ConfigureAwait(false);

        await httpClient
            .PublishToDynamicTopicAndAwaitNoNotificationsAsync(
                new()
                {
                    ProjectId = FavouriteProjectsProvider.FavouriteProjectId1,
                    Kind = ProjectNotificationKindDTO.Deleted,
                }
            )
            .ConfigureAwait(false);

        leanPipeClient.NotificationsOn(topic).Should().HaveCount(2);
    }
}
