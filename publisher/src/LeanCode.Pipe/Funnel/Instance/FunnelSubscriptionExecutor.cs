using System.Diagnostics.CodeAnalysis;
using LeanCode.Contracts;
using MassTransit;
using Microsoft.Extensions.Caching.Memory;

namespace LeanCode.Pipe.Funnel.Instance;

public class FunnelSubscriptionExecutor : ISubscriptionExecutor
{
    private readonly Serilog.ILogger logger = Serilog.Log.ForContext<FunnelSubscriptionExecutor>();

    private readonly FunnelConfiguration configuration;
    private readonly IMemoryCache memoryCache;
    private readonly IScopedClientFactory scopedClientFactory;
    private readonly IRequestClient<CheckIfTopicIsRecognized> checkTopicRecognizedRequestClient;
    private readonly IEndpointNameFormatter? endpointNameFormatter;

    public FunnelSubscriptionExecutor(
        FunnelConfiguration configuration,
        IMemoryCache memoryCache,
        IScopedClientFactory scopedClientFactory,
        IRequestClient<CheckIfTopicIsRecognized> checkTopicRecognizedRequestClient
    )
    {
        this.configuration = configuration;
        this.memoryCache = memoryCache;
        this.scopedClientFactory = scopedClientFactory;
        this.checkTopicRecognizedRequestClient = checkTopicRecognizedRequestClient;
    }

    public FunnelSubscriptionExecutor(
        FunnelConfiguration configuration,
        IMemoryCache memoryCache,
        IScopedClientFactory scopedClientFactory,
        IRequestClient<CheckIfTopicIsRecognized> checkTopicRecognizedRequestClient,
        IEndpointNameFormatter endpointNameFormatter
    )
    {
        this.configuration = configuration;
        this.memoryCache = memoryCache;
        this.scopedClientFactory = scopedClientFactory;
        this.checkTopicRecognizedRequestClient = checkTopicRecognizedRequestClient;
        this.endpointNameFormatter = endpointNameFormatter;
    }

    [SuppressMessage("Design", "CA1031:Do not catch general exception types")]
    public async Task<SubscriptionStatus> ExecuteAsync(
        SubscriptionEnvelope envelope,
        OperationType type,
        ISubscribeContext subscribeContext,
        LeanPipeContext context,
        CancellationToken ct
    )
    {
        var topicRecognized = await CheckTopicRecognizedAsync(envelope.TopicType, ct);

        if (!topicRecognized)
        {
            logger.Warning("Subscription to unrecognized topic attempted");
            return SubscriptionStatus.Malformed;
        }

        var subscriberRequestClient = GetSubscriberRequestClient(envelope.TopicType);

        try
        {
            var response = await subscriberRequestClient.GetResponse<SubscriptionPipelineResult>(
                new(envelope, type, context),
                ct
            );

            var msg = response.Message;

            if (msg.Status == SubscriptionStatus.Success)
            {
                if (type == OperationType.Subscribe)
                {
                    await subscribeContext.AddToGroupsAsync(msg.GroupKeys, ct);
                }
                else
                {
                    await subscribeContext.RemoveFromGroupsAsync(msg.GroupKeys, ct);
                }
            }

            return msg.Status;
        }
        catch (Exception e)
        {
            logger.Error(e, "LeanPipe subscription executor failed");
            return SubscriptionStatus.InternalServerError;
        }
    }

    private IRequestClient<ExecuteTopicsSubscriptionPipeline> GetSubscriberRequestClient(
        string topicType
    )
    {
        var endpoint = FunnelledSubscriberEndpointNameProvider.GetName(topicType);

        if (endpointNameFormatter is not null)
        {
            endpoint = endpointNameFormatter.SanitizeName(endpoint);
        }

        return scopedClientFactory.CreateRequestClient<ExecuteTopicsSubscriptionPipeline>(
            new Uri($"queue:{endpoint}")
        );
    }

    private Task<bool> CheckTopicRecognizedAsync(string topicType, CancellationToken ct)
    {
        return memoryCache.GetOrCreateAsync(
            new TopicRecognizedCacheKey(topicType),
            async entry =>
            {
                var topicType = ((TopicRecognizedCacheKey)entry.Key).TopicType;

                entry.AbsoluteExpirationRelativeToNow =
                    configuration.TopicRecognitionCachingTime ?? TimeSpan.FromHours(1);

                try
                {
                    await checkTopicRecognizedRequestClient.GetResponse<TopicRecognized>(
                        new(topicType),
                        ct
                    );

                    return true;
                }
                catch (RequestTimeoutException)
                {
                    return false;
                }
            }
        );
    }

    private readonly record struct TopicRecognizedCacheKey(string TopicType);
}
