import 'dart:async';

/// A structure representing subscription to a [Topic&lt;Notification&gt;].
class PipeSubscription<Notification extends Object>
    extends StreamView<Notification> {
  PipeSubscription({
    required Stream<Notification> stream,
    required Future<void> Function() unsubscribe,
  })  : _unsubscribe = unsubscribe,
        super(stream);

  final Future<void> Function() _unsubscribe;

  /// Unsubscribe to the topic.
  Future<void> unsubscribe() {
    return _unsubscribe();
  }

  // Equality is based on references, do not override equality
}
