using MassTransit;

namespace LeanCode.Pipe.Funnel.FunnelledService;

public class TopicExistenceChecker : IConsumer<CheckTopicRecognized>
{
    private readonly ITopicExtractor topicExtractor;

    public TopicExistenceChecker(ITopicExtractor topicExtractor)
    {
        this.topicExtractor = topicExtractor;
    }

    public async Task Consume(ConsumeContext<CheckTopicRecognized> context)
    {
        var topicType = context.Message.TopicType;

        if (topicExtractor.TopicExists(context.Message.TopicType))
        {
            await context.RespondAsync<TopicRecognized>(new(topicType));
        }
    }
}
