import 'dart:async';

import 'package:leancode_pipe/leancode_pipe.dart';
import 'package:leancode_pipe/leancode_pipe/contracts/contracts.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

/// A completer that will complete when the subscription is established.
typedef TopicSubscribtionCompleter = Completer<SubscriptionStatus>;

/// Manages the state and lifecycle of a subscription to a specific topic.
///
/// Handles the subscription process, reconnection, and cleanup of topic subscriptions.
/// Each [TopicSubscription] maintains its own state and can have multiple registered
/// subscriptions listening to the same topic.
class TopicSubscription {
  /// Creates a new topic subscription with the given initial state.
  TopicSubscription(
    this.topic,
    this.subscriptionId,
    TopicSubscriptionState initState,
  ) : stateSubject = BehaviorSubject.seeded(initState);

  /// Creates a new topic subscription with the given initial state.
  @visibleForTesting
  TopicSubscription.subject(this.topic, this.subscriptionId, this.stateSubject);

  /// The topic this subscription is for.
  final Topic topic;

  /// Unique identifier for this subscription.
  final String subscriptionId;

  /// Stream of subscription state changes.
  final BehaviorSubject<TopicSubscriptionState> stateSubject;

  static final _logger = Logger('TopicSubscription');

  bool _isClosed = false;

  /// Whether this subscription has been closed.
  bool get isClosed => _isClosed;

  /// Closes this subscription and all its registered subscriptions.
  ///
  /// After closing, the subscription cannot be reused.
  Future<void> close() async {
    final state = stateSubject.value;

    try {
      await Future.wait<dynamic>([
        if (state is TopicSubscriptionSubscribed)
          for (final sub in state.registeredSubscriptions)
            sub.controller.close(),
        stateSubject.close(),
      ]);

      _isClosed = true;
    } catch (err, st) {
      _logger.shout('Could not cloes a topic subscription: $this', err, st);

      _isClosed = false;
    }
  }

  @override
  String toString() =>
      'TopicSubscription(topic: $topic, subscriptionId: $subscriptionId, stateSubject: $stateSubject)';
}

/// Base class for all possible states of a topic subscription.
sealed class TopicSubscriptionState {}

/// State when a subscription is in the process of being established.
final class TopicSubscriptionSubscribing implements TopicSubscriptionState {
  /// Creates a new [TopicSubscriptionSubscribing] instance.
  TopicSubscriptionSubscribing() : completer = TopicSubscribtionCompleter();

  /// Completer that will complete when the subscription is established.
  final TopicSubscribtionCompleter completer;
}

/// Represents a registered subscription that is actively receiving notifications.
class RegisteredSubscription<N extends Object> {
  /// Creates a new [RegisteredSubscription] instance.
  RegisteredSubscription({
    required this.id,
    required this.controller,
    required Future<void> Function() unsubscribe,
    this.onReconnect,
  }) : pipeSubscription = PipeSubscription<N>(
          stream: controller.stream,
          unsubscribe: unsubscribe,
        );

  /// Unique identifier for this subscription.
  final String id;

  /// Controller for the notification stream.
  final StreamController<N> controller;

  /// The public subscription interface.
  final PipeSubscription<N> pipeSubscription;

  /// Optional callback invoked when the subscription reconnects.
  final void Function()? onReconnect;
}

/// State when a subscription is active and receiving notifications.
final class TopicSubscriptionSubscribed<N extends Object>
    implements TopicSubscriptionState {
  /// Creates a new [TopicSubscriptionSubscribed] instance.
  TopicSubscriptionSubscribed({
    required this.registeredSubscriptions,
  });

  /// List of active subscriptions for this topic.
  final List<RegisteredSubscription> registeredSubscriptions;
}

/// State when a subscription is in the process of being unsubscribed.
final class TopicSubscriptionUnsubscribing<N extends Object>
    implements TopicSubscriptionState {
  /// Creates a new [TopicSubscriptionUnsubscribing] instance.
  TopicSubscriptionUnsubscribing({
    required this.subscribedState,
  }) : completer = TopicSubscribtionCompleter();

  /// Completer that will complete when the subscription is unsubscribed.
  final TopicSubscribtionCompleter completer;

  /// The subscribed state that was being unsubscribed.
  final TopicSubscriptionSubscribed<N> subscribedState;

  /// Count of the subscriptions requests that are waiting for unsubscribe() call
  /// to complete. If [newSubscriptionRequestsCount] == 0, then after unsubscribe
  /// this subscription will be removed from registered subscriptions, while otherwise
  /// it will get registered back in the backend service.
  int newSubscriptionRequestsCount = 0;
}

/// State when a subscription is in the process of reconnecting.
final class TopicSubscriptionReconnecting implements TopicSubscriptionState {
  /// Creates a new [TopicSubscriptionReconnecting] instance.
  TopicSubscriptionReconnecting() : completer = TopicSubscribtionCompleter();

  /// Completer that will complete when the subscription is reconnected.
  final TopicSubscribtionCompleter completer;
}
