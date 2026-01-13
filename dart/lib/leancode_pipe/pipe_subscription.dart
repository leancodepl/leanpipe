import 'dart:async';

import 'package:leancode_pipe/leancode_pipe.dart';

import 'package:leancode_pipe/leancode_pipe/contracts/topic.dart';

/// Represents an active subscription to a [Topic].
///
/// Provides a stream of notifications from the topic and allows unsubscribing.
/// Each subscription is tied to a specific topic and notification type.
///
/// - ❗ Equality is based on references, do not override equality.
class PipeSubscription<Notification extends Object>
    extends StreamView<Notification> {
  /// Creates a new instance of [PipeSubscription].
  PipeSubscription({
    required Stream<Notification> stream,
    required Future<void> Function() unsubscribe,
  })  : _unsubscribe = unsubscribe,
        super(stream);

  final Future<void> Function() _unsubscribe;

  /// Unsubscribes from the topic, stopping the flow of notifications.
  ///
  /// After unsubscribing, no more notifications will be received from this subscription.
  Future<void> unsubscribe() {
    return _unsubscribe();
  }
}
