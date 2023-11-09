import 'dart:async';

import 'package:leancode_pipe/leancode_pipe.dart';
import 'package:leancode_pipe/leancode_pipe/contracts/contracts.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';

typedef TopicSubscribtionCompleter = Completer<SubscriptionStatus>;

class TopicSubscription {
  TopicSubscription(
    this.topic,
    this.subscriptionId,
    TopicSubscriptionState initState,
  ) : stateSubject = BehaviorSubject.seeded(initState);

  @visibleForTesting
  TopicSubscription.subject(this.topic, this.subscriptionId, this.stateSubject);

  final Topic topic;
  final String subscriptionId;
  final BehaviorSubject<TopicSubscriptionState> stateSubject;

  static final _logger = Logger('TopicSubscription');

  bool _isClosed = false;
  bool get isClosed => _isClosed;

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

sealed class TopicSubscriptionState {}

final class TopicSubscriptionSubscribing implements TopicSubscriptionState {
  TopicSubscriptionSubscribing() : completer = TopicSubscribtionCompleter();

  final TopicSubscribtionCompleter completer;
}

class RegisteredSubscription<N extends Object> {
  RegisteredSubscription({
    required this.id,
    required this.controller,
    required Future<void> Function() unsubscribe,
    this.onReconnect,
  }) : pipeSubscription = PipeSubscription<N>(
          stream: controller.stream,
          unsubscribe: unsubscribe,
        );

  final String id;
  final StreamController<N> controller;
  final PipeSubscription<N> pipeSubscription;
  final void Function()? onReconnect;
}

final class TopicSubscriptionSubscribed<N extends Object>
    implements TopicSubscriptionState {
  TopicSubscriptionSubscribed({
    required this.registeredSubscriptions,
  });

  final List<RegisteredSubscription> registeredSubscriptions;
}

final class TopicSubscriptionUnsubscribing<N extends Object>
    implements TopicSubscriptionState {
  TopicSubscriptionUnsubscribing({required this.subscribedState})
      : completer = TopicSubscribtionCompleter();

  final TopicSubscribtionCompleter completer;
  final TopicSubscriptionSubscribed<N> subscribedState;

  /// Count of the subscriptions requests that are waiting for unsubscribe() call
  /// to complete. If [newSubscriptionRequestsCount] == 0, then after unsubscribe
  /// this subscription will be removed from registered subscriptions, while otherwise
  /// it will get registered back in the backend service.
  int newSubscriptionRequestsCount = 0;
}

final class TopicSubscriptionReconnecting implements TopicSubscriptionState {
  TopicSubscriptionReconnecting() : completer = TopicSubscribtionCompleter();

  final TopicSubscribtionCompleter completer;
}
