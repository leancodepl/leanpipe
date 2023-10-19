namespace LeanCode.Pipe.Funnel.Instance;

public record FunnelConfiguration(TimeSpan? TopicRecognitionCachingTime)
{
    public static readonly FunnelConfiguration Default = new((TimeSpan?)null);
};
