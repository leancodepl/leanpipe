using System.Collections.Concurrent;
using System.Runtime.CompilerServices;
using System.Text.Json;
using LeanCode.Components;
using LeanCode.Contracts;
using Microsoft.AspNetCore.Http.Connections.Client;
using Microsoft.AspNetCore.SignalR.Client;
using Microsoft.Extensions.DependencyInjection;

[assembly: InternalsVisibleTo("LeanPipe.TestClient.Tests")]

namespace LeanPipe.TestClient;

public class LeanPipeTestClient : IAsyncDisposable
{
    private readonly ConcurrentDictionary<ITopic, List<object>> receivedNotifications =
        new(TopicDeepEqualityComparer.Instance);

    private readonly HubConnection hubConnection;
    private readonly NotificationEnvelopeDeserializer notificationEnvelopeDeserializer;
    private readonly JsonSerializerOptions? serializerOptions;
    private readonly TimeSpan subscriptionCompletionTimeout;

    public IReadOnlyDictionary<ITopic, List<object>> ReceivedNotifications => receivedNotifications;

    public LeanPipeTestClient(
        Uri leanPipeUrl,
        TypesCatalog leanpipeTypes,
        Action<HttpConnectionOptions>? config = null,
        JsonSerializerOptions? serializerOptions = null,
        TimeSpan? subscriptionCompletionTimeout = null
    )
    {
        hubConnection = new HubConnectionBuilder()
            .WithUrl(leanPipeUrl, config!)
            .AddJsonProtocol(options =>
            {
                options.PayloadSerializerOptions.PropertyNamingPolicy = null;
            })
            .Build();

        notificationEnvelopeDeserializer = new(leanpipeTypes, serializerOptions);

        this.serializerOptions = serializerOptions;
        this.subscriptionCompletionTimeout =
            subscriptionCompletionTimeout ?? TimeSpan.FromSeconds(10);

        hubConnection.On<NotificationEnvelope>(
            "notify",
            n =>
            {
                if (notificationEnvelopeDeserializer.Deserialize(n) is var (topic, notification))
                {
                    receivedNotifications.GetValueOrDefault(topic)?.Add(notification);
                }
            }
        );
    }

    public async Task<SubscriptionResult?> UnsubscribeAsync<TTopic>(
        TTopic topic,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        if (hubConnection.State != HubConnectionState.Connected)
        {
            return new(default, SubscriptionStatus.Success, OperationType.Unsubscribe);
        }

        return await ManageSubscriptionCoreAsync(topic, OperationType.Unsubscribe, ct);
    }

    public async Task<SubscriptionResult?> SubscribeAsync<TTopic>(
        TTopic topic,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        if (hubConnection.State != HubConnectionState.Connected)
        {
            await ConnectAsync(ct);
        }

        var result = await ManageSubscriptionCoreAsync(topic, OperationType.Subscribe, ct);

        if (result?.Status == SubscriptionStatus.Success)
        {
            receivedNotifications.TryAdd(topic, new());
        }

        return result;
    }

    public Task ConnectAsync(CancellationToken ct = default) => hubConnection.StartAsync(ct);

    /// <remarks>
    /// Also clears all subscriptions.
    /// </remarks>
    public Task DisconnectAsync(CancellationToken ct = default) => hubConnection.StopAsync(ct);

    public async ValueTask DisposeAsync()
    {
        await hubConnection.DisposeAsync();

        GC.SuppressFinalize(this);
    }

    private async Task<SubscriptionResult?> ManageSubscriptionCoreAsync<TTopic>(
        TTopic topic,
        OperationType operationType,
        CancellationToken ct
    )
    {
        var topicType = typeof(TTopic);

        var subscriptionEnvelope = new SubscriptionEnvelope
        {
            Id = Guid.NewGuid(),
            TopicType = topicType.FullName!,
            Topic = JsonSerializer.SerializeToDocument(topic, serializerOptions),
        };

        var subscriptionCompletionSource = new TaskCompletionSource<SubscriptionResult>();

        using var subscriptionResponseCallback = hubConnection.On<SubscriptionResult>(
            "subscriptionResult",
            r =>
            {
                if (r.SubscriptionId == subscriptionEnvelope.Id && r.Type == operationType)
                {
                    subscriptionCompletionSource.TrySetResult(r);
                }
            }
        );

        await hubConnection.InvokeAsync(
            nameof(LeanPipeSubscriber.Subscribe),
            subscriptionEnvelope,
            ct
        );

        if (
            await Task.WhenAny(
                subscriptionCompletionSource.Task,
                Task.Delay(subscriptionCompletionTimeout, ct)
            ) == subscriptionCompletionSource.Task
        )
        {
            return subscriptionCompletionSource.Task.Result;
        }

        return null;
    }
}
