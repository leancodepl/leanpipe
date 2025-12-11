using LeanCode.Pipe.Funnel.Core;
using MassTransit;

namespace LeanCode.Pipe.Funnel.Publishing;

public class TopicExistenceChecker : IConsumer<CheckIfTopicIsRecognized>
{
    private readonly ITopicExtractor topicExtractor;

    public TopicExistenceChecker(ITopicExtractor topicExtractor)
    {
        this.topicExtractor = topicExtractor;
    }

    public async Task Consume(ConsumeContext<CheckIfTopicIsRecognized> context)
    {
        var topicType = context.Message.TopicType;

        if (topicExtractor.TopicExists(context.Message.TopicType))
        {
            await context.RespondAsync<TopicRecognized>(new(topicType));
        }
    }
}
