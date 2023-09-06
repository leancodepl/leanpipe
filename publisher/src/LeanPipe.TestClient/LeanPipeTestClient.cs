using System.Collections.Concurrent;
using System.Text.Json;
using LeanCode.Contracts;
using Microsoft.AspNetCore.Http.Connections.Client;
using Microsoft.AspNetCore.SignalR.Client;
using Microsoft.Extensions.DependencyInjection;

namespace LeanPipe.TestClient;

public class LeanPipeTestClient : IAsyncDisposable
{
    private readonly ConcurrentDictionary<ITopic, List<object>> receivedNotifications = new();

    private readonly HubConnection hubConnection;
    private readonly JsonSerializerOptions? serializerOptions;
    private readonly TimeSpan subscriptionCompletionTimeout;

    public IReadOnlyDictionary<ITopic, List<object>> ReceivedNotifications => receivedNotifications;

    public LeanPipeTestClient(
        Uri leanpipeUrl,
        Action<HttpConnectionOptions>? config = null,
        JsonSerializerOptions? serializerOptions = null,
        TimeSpan? subscriptionCompletionTimeout = null
    )
    {
        hubConnection = new HubConnectionBuilder()
            .WithUrl(leanpipeUrl, config!)
            .AddJsonProtocol(
                options => options.PayloadSerializerOptions.PropertyNamingPolicy = null
            )
            .Build();

        hubConnection.On<NotificationEnvelope>(
            "notify",
            n =>
            {
                var topicType = Type.GetType(n.TopicType);

                if (topicType is null)
                {
                    return;
                }

                var serializedTopic = JsonSerializer.SerializeToUtf8Bytes(
                    n.Topic,
                    topicType,
                    serializerOptions
                );

                var subscription = receivedNotifications
                    .Select(n => (KeyValuePair<ITopic, List<object>>?)n)
                    .FirstOrDefault(
                        t =>
                            JsonSerializer
                                .SerializeToUtf8Bytes(t!.Value.Key, serializerOptions)
                                .SequenceEqual(serializedTopic)
                    );

                subscription?.Value.Add(n.Notification);
            }
        );

        this.serializerOptions = serializerOptions;
        this.subscriptionCompletionTimeout =
            subscriptionCompletionTimeout ?? TimeSpan.FromSeconds(10);
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
                if (
                    r.SubscriptionId == subscriptionEnvelope.Id
                    && r.Type == OperationType.Unsubscribe
                )
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
                if (
                    r.SubscriptionId == subscriptionEnvelope.Id && r.Type == OperationType.Subscribe
                )
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
            ) != subscriptionCompletionSource.Task
        )
        {
            return null;
        }

        var result = subscriptionCompletionSource.Task.Result;

        if (result.Status == SubscriptionStatus.Success)
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
}
