import 'dart:async';

import 'package:collection/collection.dart';
import 'package:leancode_pipe/leancode_pipe/contracts/contracts.dart';
import 'package:leancode_pipe/leancode_pipe/contracts/topic.dart';
import 'package:leancode_pipe/leancode_pipe/create_hub_connection.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_connection_state.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_connection_state_mapper.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_error.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_subscription.dart';
import 'package:leancode_pipe/leancode_pipe/topic_subscription.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';
import 'package:signalr_core/signalr_core.dart';
import 'package:uuid/uuid.dart';

typedef OnPipeAction<T> = void Function(T value);
typedef PipeTokenFactory = Future<String> Function();

class PipeClient {
  factory PipeClient({
    required String pipeUrl,
    required PipeTokenFactory tokenFactory,
    void Function()? onReconnected,
    OnPipeAction<Exception?>? onReconnecting,
    OnPipeAction<Exception?>? onClose,
  }) =>
      PipeClient.fromMock(
        hubConnection: createHubConnection(
          pipeUrl: pipeUrl,
          tokenFactory: tokenFactory,
        ),
        onReconnected: onReconnected,
        onReconnecting: onReconnecting,
        onClose: onClose,
      );

  @visibleForTesting
  PipeClient.fromMock({
    required HubConnection hubConnection,
    Uuid uuid = const Uuid(),
    this.onReconnected,
    this.onReconnecting,
    this.onClose,
  })  : _hubConnection = hubConnection,
        _uuid = uuid;

  final HubConnection _hubConnection;
  final Uuid _uuid;

  static const _topicSubscriptionReconnectsCount = 3;
  static const _signalRRequestTimeoutDuration = Duration(seconds: 30);

  final void Function()? onReconnected;
  final OnPipeAction<Exception?>? onReconnecting;
  final OnPipeAction<Exception?>? onClose;

  static final _logger = Logger('PipeClient');
  final _registeredTopicSubscriptions = <TopicSubscription>[];

  PipeConnectionState get connectionState =>
      PipeConnectionStateMapper.fromHubConnectionState(
        _hubConnection.state,
      );

  Future<void> connect() async {
    if (connectionState != PipeConnectionState.disconnected) {
      _logger.warning(
        'Tried to connect to the pipe while connection is already opened.',
      );
      return;
    }

    try {
      _hubConnection
        ..onreconnected((connectionId) async {
          await Future.wait([
            for (final topicSub in _registeredTopicSubscriptions)
              _reconnect(topicSub),
          ]);
          onReconnected?.call();
        })
        ..onreconnecting((error) {
          onReconnecting?.call(error);
        })
        ..onclose((error) async {
          await Future.wait([
            for (final topicSub in _registeredTopicSubscriptions)
              topicSub.close(),
          ]);
          onClose?.call(error);
        })
        ..on('subscriptionResult', _onSubscriptionResult)
        ..on('notify', _onNotify);
      await _hubConnection.start();
    } catch (err, st) {
      _logger.shout('Could not connect to LeanCode pipe service', err, st);
      throw const PipeConnectionException();
    }
  }

  Future<void> disconnect() async {
    if (connectionState == PipeConnectionState.disconnected) {
      _logger.fine(
        'Tried to disconnect while pipe is not connected',
      );
      return;
    }

    try {
      await _hubConnection.stop();
    } catch (err, st) {
      _logger.shout('Could not disconnect from LeanCode pipe service', err, st);
      rethrow;
    }
  }

  Future<PipeSubscription<N>> subscribe<N extends Object>(
    Topic<N> topic, {
    void Function()? onReconnect,
  }) async {
    final thisTopicSubscription =
        _registeredTopicSubscriptions.firstWhereOrNull((e) => e.topic == topic);

    if (thisTopicSubscription != null) {
      final state = thisTopicSubscription.stateSubject.value;
      switch (state) {
        case TopicSubscriptionSubscribed():
          return _registerSubscription(
            subscribedState: state,
            onReconnect: onReconnect,
            topic: topic,
          );
        case TopicSubscriptionUnsubscribing():
          // Mark topic subscription to not be fully removed after unsubscribe
          state.newSubscriptionRequestsCount++;
          final index = state.newSubscriptionRequestsCount;

          // Subscription process will continue after unsubscribing future
          await state.completer.future;

          if (index == 1) {
            // Prepare for subscribing
            final subscribingState = TopicSubscriptionSubscribing();
            thisTopicSubscription.stateSubject.add(subscribingState);

            // Subscribe on backend and return a valid pipe subscription
            // (or throw an exception)
            return _sendSubscribeMethodAndVerifyResult(
              subscribingState: subscribingState,
              subscription: thisTopicSubscription,
              onReconnect: onReconnect,
              subscriptionId: thisTopicSubscription.subscriptionId,
              topic: topic,
            );
          } else {
            // Recurrence should now find the topic subscription in different state
            // than unsubscribing (either subscribing or subscribed)
            await Future<void>.delayed(const Duration(milliseconds: 100));
            return subscribe(topic, onReconnect: onReconnect);
          }

        case TopicSubscriptionSubscribing():
        case TopicSubscriptionReconnecting():
          try {
            final state = await thisTopicSubscription.stateSubject
                .doOnError((err, st) {
                  _logger.info(
                    'Caught error in second subscription call, while already subscribing/reconnecting.'
                    'Will attempt to connect subscribe either way.',
                    err,
                    st,
                  );
                  throw const PipeConnectionException();
                })
                .whereType<TopicSubscriptionSubscribed>()
                .first;

            return _registerSubscription(
              subscribedState: state,
              onReconnect: onReconnect,
              topic: topic,
            );
          } catch (_) {
            // Continue with subscription process logic below
          }
      }
    }

    // Register subscription in SignalR
    final subscriptionId = _uuid.v4();

    // Register subscription in pipe client
    final subscribingState = TopicSubscriptionSubscribing();
    final subscription =
        TopicSubscription(topic, subscriptionId, subscribingState);

    _registeredTopicSubscriptions.add(subscription);

    return _sendSubscribeMethodAndVerifyResult(
      subscribingState: subscribingState,
      subscription: subscription,
      onReconnect: onReconnect,
      subscriptionId: subscriptionId,
      topic: topic,
    );
  }

  PipeSubscription<N> _registerSubscription<N extends Object>({
    required TopicSubscriptionSubscribed subscribedState,
    required Topic<N> topic,
    required void Function()? onReconnect,
  }) {
    final controller = StreamController<N>.broadcast();
    // v1 is used for easier mocking in tests to differentiate between the internal IDs and server IDs
    final id = _uuid.v1();
    final subscription = RegisteredSubscription(
      id: id,
      controller: controller,
      unsubscribe: () => _unsubscribe(topic, id),
      onReconnect: onReconnect,
    );

    subscribedState.registeredSubscriptions.add(subscription);

    return subscription.pipeSubscription;
  }

  Future<PipeSubscription<N>>
      _sendSubscribeMethodAndVerifyResult<N extends Object>({
    required Topic<N> topic,
    required String subscriptionId,
    required TopicSubscriptionSubscribing subscribingState,
    required TopicSubscription subscription,
    required void Function()? onReconnect,
  }) async {
    // Register topic subscription in backend service
    try {
      final result = await _sendPipeServiceMethod(
        topic: topic,
        subscriptionId: subscriptionId,
        completer: subscribingState.completer,
        method: _PipeServiceMethod.subscribe,
      );

      switch (result) {
        case SubscriptionStatus.success:
          // Create [TopicSubscriptionSubscribed] state and add it to states stream of subscription
          final subscribedState = TopicSubscriptionSubscribed(
            registeredSubscriptions: [],
          );
          final pipeSubscription = _registerSubscription<N>(
            subscribedState: subscribedState,
            topic: topic,
            onReconnect: onReconnect,
          );

          subscription.stateSubject.add(subscribedState);

          return pipeSubscription;
        case SubscriptionStatus.internalServerError:
        case SubscriptionStatus.invalid:
        case SubscriptionStatus.malformed:
          throw const PipeServerException();
        case SubscriptionStatus.unauthorized:
          throw const PipeUnauthorizedException();
      }
    } catch (_) {
      await subscription.close();
      rethrow;
    }
  }

  Future<void> _unsubscribe(Topic topic, String id) async {
    final thisTopicSubscription =
        _registeredTopicSubscriptions.firstWhereOrNull((e) => e.topic == topic);

    if (thisTopicSubscription == null) {
      throw StateError(
        'There is no ongoing subscription to requested to unsubscribe topic: $topic',
      );
    }

    final state = thisTopicSubscription.stateSubject.value;

    final TopicSubscriptionSubscribed subscribedState;
    switch (state) {
      case TopicSubscriptionUnsubscribing():
        await state.completer.future;
        return;

      case TopicSubscriptionSubscribing():
        throw StateError(
          'Can not unsubscribe from a not registered subscription',
        );
      case TopicSubscriptionReconnecting():
        try {
          subscribedState = await thisTopicSubscription.stateSubject
              .doOnError((err, st) {
                // ignore: only_throw_errors
                throw err;
              })
              .whereType<TopicSubscriptionSubscribed>()
              .first
              .timeout(_signalRRequestTimeoutDuration);
        } on PipeReconnectException catch (_) {
          // Could not reconnect which means that subscription is not
          // tied up with the backend service - in such scenario we can
          // asume that unsubscribe finished successfully
          _logger.fine(
            'Unsubscribe on topic: $topic completed successfully '
            'because of a reconnect failure.',
          );
          return;
        } catch (err, st) {
          _logger.shout(
            'Failed to find a valid subscribed state while unsubscribing '
            'on topic: $topic.',
            err,
            st,
          );
          rethrow;
        }

      case TopicSubscriptionSubscribed():
        subscribedState = state;
    }

    if (subscribedState.registeredSubscriptions.length > 1) {
      final subscription =
          subscribedState.registeredSubscriptions.firstWhere((e) => e.id == id);

      subscribedState.registeredSubscriptions.remove(subscription);

      await subscription.controller.close();
      return;
    }

    // Add unsubscribing state to pipe client
    final unsubscribingState = TopicSubscriptionUnsubscribing(
      // Close the notifications stream controller before complete
      // to keep async operations together
      subscribedState: subscribedState,
    );
    thisTopicSubscription.stateSubject.add(unsubscribingState);

    // Unregister subscription in backend service
    final result = await _sendPipeServiceMethod(
      topic: topic,
      subscriptionId: thisTopicSubscription.subscriptionId,
      completer: unsubscribingState.completer,
      method: _PipeServiceMethod.unsubscribe,
    );

    switch (result) {
      case SubscriptionStatus.success:
        // If another subscription is waiting for unsubscribe to persume with
        // subscribe logic then clear registered subscriptions but leave the
        // topic subscription in [_registeredTopicSubscriptions]
        if (unsubscribingState.newSubscriptionRequestsCount > 0) {
          subscribedState.registeredSubscriptions.clear();
          return;
        }

        // Close streams tied up with this subscription
        await Future.wait([
          thisTopicSubscription.stateSubject.close(),
          for (final subscription in subscribedState.registeredSubscriptions)
            subscription.controller.close(),
        ]);

        // Remove subscription from registered topic subscriptions
        _registeredTopicSubscriptions.remove(thisTopicSubscription);

      case SubscriptionStatus.internalServerError:
        throw const PipeServerException();
      case SubscriptionStatus.invalid:
      case SubscriptionStatus.malformed:
        throw StateError('Internal Pipe error');
      case SubscriptionStatus.unauthorized:
        throw StateError('Unsubscribes should not need authorization');
    }
  }

  Future<bool> _reconnect(TopicSubscription topicSubscription) async {
    final topic = topicSubscription.topic;
    final state = topicSubscription.stateSubject.value;

    if (state is! TopicSubscriptionSubscribed) {
      // Skip if not subscribed
      return false;
    }

    final reconnectingState = TopicSubscriptionReconnecting();
    topicSubscription.stateSubject.add(reconnectingState);

    for (var i = 0; i < _topicSubscriptionReconnectsCount; i++) {
      // Register topic subscription in backend service
      try {
        final result = await _sendPipeServiceMethod<SubscriptionStatus>(
          topic: topic,
          subscriptionId: topicSubscription.subscriptionId,
          completer: reconnectingState.completer,
          method: _PipeServiceMethod.subscribe,
          // SubscriptionStatus type in this case can be ignored
          onTimeout: () => SubscriptionStatus.invalid,
        );

        if (result == SubscriptionStatus.success) {
          _logger.info(
            'Successfully reconnected subscription: $topicSubscription',
          );

          topicSubscription.stateSubject.add(state);

          for (final sub in state.registeredSubscriptions) {
            sub.onReconnect?.call();
          }

          return true;
        }

        // This reconnecting state completer is already completed so we have to
        // send an another reconnecting state into the states subject
        topicSubscription.stateSubject.add(TopicSubscriptionReconnecting());
      } catch (err, st) {
        _logger.info(
          'Could not reconnect on ${i + 1} attempt, subscription: $topicSubscription',
          err,
          st,
        );
      }
    }

    // If failed to reconnect then add an error to the stream and close the controller
    topicSubscription.stateSubject.addError(const PipeReconnectException());
    await Future.wait([
      topicSubscription.close(),
      for (final sub in state.registeredSubscriptions)
        () async {
          sub.controller.addError(const PipeReconnectException());
          await sub.controller.close();
          state.registeredSubscriptions.remove(sub);
        }(),
    ]);

    // Subscription is no longer maintained so remove it from registered subscriptions
    _registeredTopicSubscriptions.remove(topicSubscription);

    return false;
  }

  Future<void> _onSubscriptionResult(List<dynamic>? args) async {
    final subscriptionData = args?.firstOrNull as Map<String, dynamic>?;
    if (subscriptionData != null) {
      final subscriptionResult = SubscriptionResult.fromJson(subscriptionData);

      final subscription = _registeredTopicSubscriptions.firstWhereOrNull(
        (e) => e.subscriptionId == subscriptionResult.subscriptionId,
      );

      if (subscription == null) {
        _logger.warning(
          'Could not find subscription for subscriptionId: ${subscriptionResult.subscriptionId}',
        );
        return;
      }

      _logger.finest('Received subscription: $subscriptionResult');

      final state = subscription.stateSubject.value;

      switch (subscriptionResult.type) {
        case OperationType.subscribe:
          switch (state) {
            case TopicSubscriptionUnsubscribing():
            case TopicSubscriptionSubscribed():
              throw StateError('Internal Pipe error');
            case TopicSubscriptionSubscribing():
              state.completer.complete(subscriptionResult.status);
              return;
            case TopicSubscriptionReconnecting():
              state.completer.complete(subscriptionResult.status);
              return;
          }
        case OperationType.unsubscribe:
          switch (state) {
            case TopicSubscriptionUnsubscribing():
              // Async operation called before completer completes
              await Future.wait([
                for (final sub in state.subscribedState.registeredSubscriptions)
                  sub.controller.close(),
              ]);
              state.completer.complete(subscriptionResult.status);
              return;
            case TopicSubscriptionSubscribed():
            case TopicSubscriptionSubscribing():
            case TopicSubscriptionReconnecting():
              throw StateError('Internal Pipe error');
          }
      }
    }
  }

  void _onNotify(List<dynamic>? args) {
    final notificationData = args?.firstOrNull as Map<String, dynamic>?;
    if (notificationData != null) {
      final envelope = NotificationEnvelope.fromJson(notificationData);

      _logger.finest('Received notifciation: $envelope');

      final topicTypeSubscriptions = _registeredTopicSubscriptions
          .where((e) => e.topic.getFullName() == envelope.topicType);
      if (topicTypeSubscriptions.isEmpty) {
        _logger.fine(
          'Could not match received notification to parent topic. '
          'Type: ${envelope.topicType}',
        );
        return;
      }

      final subscription = topicTypeSubscriptions.firstWhereOrNull((e) {
        final topicFromEnvelope = e.topic.fromJson(envelope.topic);
        return topicFromEnvelope == e.topic;
      });
      if (subscription == null) {
        _logger.fine(
          'Received notification topic was not equal to registered subscription topic'
          'Topic: ${envelope.topic}',
        );
        return;
      }

      final state = subscription.stateSubject.value;
      switch (state) {
        case TopicSubscriptionSubscribed():
          final notification = subscription.topic.castNotification(
            envelope.notificationType,
            envelope.notification,
          );

          if (notification != null) {
            for (final sub in state.registeredSubscriptions) {
              sub.controller.add(notification);
            }
          }
          return;
        case TopicSubscriptionUnsubscribing():
        case TopicSubscriptionSubscribing():
        case TopicSubscriptionReconnecting():
          // We can do nothing with that information
          return;
      }
    }
  }

  Future<void> dispose() async {
    await Future.wait(_registeredTopicSubscriptions.map((e) => e.close()));
    await _hubConnection.stop();
  }

  Future<R> _sendPipeServiceMethod<R extends Object>({
    required String subscriptionId,
    required Topic topic,
    required Completer<R> completer,
    required _PipeServiceMethod method,
    FutureOr<R> Function()? onTimeout,
  }) async {
    final envelope = SubscriptionEnvelope(
      id: subscriptionId,
      topic: topic.toJson(),
      topicType: topic.getFullName(),
    );

    // Register topic subscription in backend service
    await _hubConnection.send(
      methodName: method.methodName,
      args: [envelope],
    );

    final result = await completer.future.catchError(
      (dynamic errorOrException) {
        if (errorOrException is Exception) {
          throw errorOrException;
        } else {
          throw errorOrException as Error;
        }
      },
    ).timeout(
      _signalRRequestTimeoutDuration,
      onTimeout: onTimeout,
    );

    return result;
  }
}

enum _PipeServiceMethod {
  subscribe('Subscribe'),
  unsubscribe('Unsubscribe');

  const _PipeServiceMethod(this.methodName);

  final String methodName;
}
