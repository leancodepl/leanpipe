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
    private readonly ConcurrentDictionary<ITopic, LeanPipeSubscription> subscriptions =
        new(TopicDeepEqualityComparer.Instance);

    private readonly HubConnection hubConnection;
    private readonly NotificationEnvelopeDeserializer notificationEnvelopeDeserializer;
    private readonly JsonSerializerOptions? serializerOptions;
    private readonly TimeSpan subscriptionCompletionTimeout;

    public IReadOnlyDictionary<ITopic, LeanPipeSubscription> Subscriptions => subscriptions;

    public LeanPipeTestClient(
        Uri leanPipeUrl,
        TypesCatalog leanPipeTypes,
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

        hubConnection.Closed += e =>
        {
            foreach (var subscription in subscriptions.Values)
            {
                subscription.Unsubscribe();
            }

            if (e is not null)
            {
                throw e;
            }

            return Task.CompletedTask;
        };

        notificationEnvelopeDeserializer = new(leanPipeTypes, serializerOptions);

        this.serializerOptions = serializerOptions;
        this.subscriptionCompletionTimeout =
            subscriptionCompletionTimeout ?? TimeSpan.FromSeconds(10);

        hubConnection.On<NotificationEnvelope>(
            "notify",
            n =>
            {
                if (notificationEnvelopeDeserializer.Deserialize(n) is var (topic, notification))
                {
                    subscriptions.GetValueOrDefault(topic)?.AddNotification(notification);
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
        SubscriptionResult? result;

        if (hubConnection.State != HubConnectionState.Connected)
        {
            result = new(default, SubscriptionStatus.Success, OperationType.Unsubscribe);
        }
        else
        {
            result = await ManageSubscriptionCoreAsync(topic, OperationType.Unsubscribe, ct);
        }

        if (result?.Status == SubscriptionStatus.Success)
        {
            subscriptions.GetValueOrDefault(topic)?.Unsubscribe();
        }

        return result;
    }

    public async Task<SubscriptionResult?> SubscribeAsync<TTopic>(
        TTopic topic,
        CancellationToken ct = default
    )
        where TTopic : ITopic
    {
        var subscription = subscriptions.GetValueOrDefault(topic);

        if (subscription?.SubscriptionId is not null)
        {
            throw new InvalidOperationException("Already subscribed to topic.");
        }

        if (hubConnection.State != HubConnectionState.Connected)
        {
            await ConnectAsync(ct);
        }

        var result = await ManageSubscriptionCoreAsync(topic, OperationType.Subscribe, ct);

        if (result?.Status == SubscriptionStatus.Success)
        {
            if (subscription is not null)
            {
                subscription.Subscribe(result.SubscriptionId);
            }
            else
            {
                subscriptions[topic] = new(topic, result.SubscriptionId);
            }
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
        where TTopic : ITopic
    {
        var topicType = typeof(TTopic);

        var subscriptionEnvelope = new SubscriptionEnvelope
        {
            Id = subscriptions.GetValueOrDefault(topic)?.SubscriptionId ?? Guid.NewGuid(),
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
            operationType switch
            {
                OperationType.Subscribe => nameof(LeanPipeSubscriber.Subscribe),
                OperationType.Unsubscribe => nameof(LeanPipeSubscriber.Unsubscribe),
                _
                    => throw new ArgumentOutOfRangeException(
                        nameof(operationType),
                        operationType,
                        "LeanPipe OperationType is out of range."
                    ),
            },
            subscriptionEnvelope,
            ct
        );

        return await AwaitWithTimeout(
            subscriptionCompletionSource.Task,
            subscriptionCompletionTimeout,
            ct
        );
    }

    internal static async Task<TResult?> AwaitWithTimeout<TResult>(
        Task<TResult> task,
        TimeSpan timeout,
        CancellationToken ct
    )
        where TResult : class
    {
        return await Task.WhenAny(task, Task.Delay(timeout, ct)) == task ? task.Result : null;
    }
}
