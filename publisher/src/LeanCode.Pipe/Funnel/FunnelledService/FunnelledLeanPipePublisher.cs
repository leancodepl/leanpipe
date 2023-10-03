using LeanCode.Contracts;
using MassTransit;
using MassTransit.SignalR.Contracts;
using MassTransit.SignalR.Utils;
using Microsoft.AspNetCore.SignalR.Protocol;

namespace LeanCode.Pipe.Funnel.FunnelledService;

internal class FunnelledLeanPipePublisher<TTopic> : ILeanPipePublisher<TTopic>
    where TTopic : ITopic
{
    private IPublishEndpoint PublishEndpoint { get; }
    public IServiceProvider ServiceProvider { get; }

    public FunnelledLeanPipePublisher(
        IPublishEndpoint publishEndpoint,
        IServiceProvider serviceProvider
    )
    {
        PublishEndpoint = publishEndpoint;
        ServiceProvider = serviceProvider;
    }

    public Task PublishAsync(
        IEnumerable<string> keys,
        NotificationEnvelope payload,
        CancellationToken cancellationToken = default
    )
    {
        // TODO: Pass JSON options here
        var protocolDictionary = new[] { new JsonHubProtocol() }.ToProtocolDictionary(
            "notify",
            new object[] { payload }
        );

        var publishTasks = keys.Where(k => !string.IsNullOrEmpty(k))
            .Select(
                k =>
                    PublishEndpoint.Publish<Group<LeanPipeSubscriber>>(
                        new { GroupName = k, Messages = protocolDictionary, },
                        cancellationToken
                    )
            );

        return Task.WhenAll(publishTasks);
    }
}
