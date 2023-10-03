using LeanCode.Contracts;

namespace LeanCode.Pipe.Funnel;

public static class FunnelledSubscriberEndpointNameProvider
{
    public static string GetName<TTopic>()
        where TTopic : ITopic => GetName(typeof(TTopic).FullName!);

    public static string GetName(string topicTypeFullName)
    {
        return $"leanpipefunnelledsubscriber_{topicTypeFullName}";
    }
}
