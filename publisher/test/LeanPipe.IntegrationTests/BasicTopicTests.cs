using System.Net.Http.Json;
using FluentAssertions;
using LeanPipe.IntegrationTests.App;
using LeanPipe.TestClient;
using Xunit;

namespace LeanPipe.IntegrationTests;

public class BasicTopicTests : TestApplicationFactory
{
    private readonly HttpClient httpClient;
    private readonly LeanPipeTestClient leanPipeClient;

    public BasicTopicTests()
    {
        httpClient = CreateClient();
        leanPipeClient = new(
            new("http://localhost/leanpipe"),
            Program.LeanPipeTypes,
            hco =>
            {
                hco.HttpMessageHandlerFactory = _ => Server.CreateHandler();
            }
        );
    }

    [Fact]
    public async Task Basic_topic_subscriber_receives_both_kinds_of_messages()
    {
        var topic = new UnauthorizedTopic { TopicId = Guid.NewGuid() };

        await leanPipeClient.SubscribeSuccessAsync(topic);
        leanPipeClient.NotificationsOn(topic).Should().BeEmpty();

        var notificationTask = leanPipeClient.GetNextNotificationTaskOn(topic);
        await httpClient.PostAsJsonAsync(
            "/publish_unauthorized",
            new NotificationDataDTO
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Greeting,
                Name = "Tester",
            }
        );

        (await notificationTask).Should()
            .BeEquivalentTo(new GreetingNotificationDTO { Greeting = "Hello Tester" });

        notificationTask = leanPipeClient.GetNextNotificationTaskOn(topic);
        await httpClient.PostAsJsonAsync(
            "/publish_unauthorized",
            new NotificationDataDTO
            {
                TopicId = topic.TopicId,
                Kind = NotificationKindDTO.Farewell,
                Name = "Tester",
            }
        );

        (await notificationTask).Should()
            .BeEquivalentTo(new FarewellNotificationDTO { Farewell = "Goodbye Tester" });

        await leanPipeClient.UnsubscribeSuccessAsync(topic);
    }
}
