using System.Reflection;
using MassTransit;

namespace LeanCode.Pipe.Funnel.FunnelledService;

public class TopicExistenceChecker : IConsumer<CheckTopicRecognized>
{
    private readonly IEnvelopeDeserializer envelopeDeserializer;

    public TopicExistenceChecker(IEnvelopeDeserializer envelopeDeserializer)
    {
        this.envelopeDeserializer = envelopeDeserializer;
    }

    public async Task Consume(ConsumeContext<CheckTopicRecognized> context)
    {
        var topicType = context.Message.TopicType;

        if (envelopeDeserializer.TopicExists(context.Message.TopicType))
        {
            await context.RespondAsync<TopicRecognized>(new(topicType));
        }
    }
}
