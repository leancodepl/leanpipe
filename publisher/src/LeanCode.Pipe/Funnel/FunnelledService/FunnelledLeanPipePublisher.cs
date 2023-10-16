using System.Collections.Immutable;
using LeanCode.Contracts;
using MassTransit;
using MassTransit.SignalR.Contracts;
using MassTransit.SignalR.Utils;
using Microsoft.AspNetCore.SignalR.Protocol;
using Microsoft.Extensions.DependencyInjection;

namespace LeanCode.Pipe.Funnel.FunnelledService;

internal class FunnelledLeanPipePublisher<TTopic> : ILeanPipePublisher<TTopic>
    where TTopic : ITopic
{
    private static readonly ImmutableArray<IHubProtocol> LeanPipeHubProtocols =
        ImmutableArray.Create<IHubProtocol>(new JsonHubProtocol());

    private readonly IPublishEndpoint publishEndpoint;
    private readonly IServiceProvider serviceProvider;

    public FunnelledLeanPipePublisher(
        IPublishEndpoint publishEndpoint,
        IServiceProvider serviceProvider
    )
    {
        this.publishEndpoint = publishEndpoint;
        this.serviceProvider = serviceProvider;
    }

    public IPublishingKeys<T, TNotification> GetPublishingKeysProvider<T, TNotification>()
        where T : ITopic, IProduceNotification<TNotification>
        where TNotification : notnull
    {
        return serviceProvider.GetRequiredService<IPublishingKeys<T, TNotification>>();
    }

    public async Task PublishAsync(
        IEnumerable<string> keys,
        NotificationEnvelope payload,
        CancellationToken cancellationToken = default
    )
    {
        var protocolDictionary = LeanPipeHubProtocols.ToProtocolDictionary(
            "notify",
            new object[] { payload }
        );

        var publishTasks = keys.Where(k => !string.IsNullOrEmpty(k))
            .Select(
                k =>
                    publishEndpoint.Publish<Group<LeanPipeSubscriber>>(
                        new { GroupName = k, Messages = protocolDictionary, },
                        cancellationToken
                    )
            );

        await Task.WhenAll(publishTasks);
    }
}
