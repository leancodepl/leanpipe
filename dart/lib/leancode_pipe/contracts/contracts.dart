import 'package:json_annotation/json_annotation.dart';

part 'contracts.g.dart';

const _pipeContractsSerializable = JsonSerializable(
  fieldRename: FieldRename.pascal,
);

/// Result of a subscription operation returned by the server.
@_pipeContractsSerializable
class SubscriptionResult {
  /// Creates a new [SubscriptionResult] instance.
  const SubscriptionResult({
    required this.subscriptionId,
    required this.status,
    required this.type,
  });

  /// Creates a new [SubscriptionResult] instance from a JSON object.
  factory SubscriptionResult.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResultFromJson(json);

  /// Unique identifier for the subscription.
  final String subscriptionId;

  /// Status of the subscription operation.
  final SubscriptionStatus status;

  /// Type of operation (subscribe/unsubscribe).
  final OperationType type;

  /// Converts the subscription result to a JSON object.
  Map<String, dynamic> toJson() => _$SubscriptionResultToJson(this);
}

/// Status codes returned by the server for subscription operations.
enum SubscriptionStatus {
  /// Operation completed successfully.
  @JsonValue(0)
  success,

  /// Client is not authorized to perform the operation.
  @JsonValue(1)
  unauthorized,

  /// Request was malformed.
  @JsonValue(2)
  malformed,

  /// Request was invalid.
  @JsonValue(3)
  invalid,

  /// Server encountered an internal error.
  @JsonValue(4)
  internalServerError,
}

/// Types of subscription operations.
enum OperationType {
  /// Subscribe to a topic.
  @JsonValue(0)
  subscribe,

  /// Unsubscribe from a topic.
  @JsonValue(1)
  unsubscribe,
}

/// Envelope containing a notification sent by the server.
@_pipeContractsSerializable
class NotificationEnvelope {
  /// Creates a new [NotificationEnvelope] instance.
  const NotificationEnvelope({
    required this.id,
    required this.topicType,
    required this.notificationType,
    required this.topic,
    required this.notification,
  });

  /// Creates a new [NotificationEnvelope] instance from a JSON object.
  factory NotificationEnvelope.fromJson(Map<String, dynamic> json) =>
      _$NotificationEnvelopeFromJson(json);

  /// Unique identifier for this notification.
  final String id;

  /// Full name of the topic type.
  final String topicType;

  /// Type of the notification.
  final String notificationType;

  /// Topic data in JSON format.
  final Map<String, dynamic> topic;

  /// The notification payload.
  final Object notification;

  /// Converts the notification envelope to a JSON object.
  Map<String, dynamic> toJson() => _$NotificationEnvelopeToJson(this);

  @override
  String toString() {
    return 'NotificationEnvelope(id: $id, topicType: $topicType, notificationType: $notificationType, topic: $topic, notification: $notification)';
  }
}

/// Envelope containing subscription request data sent to the server.
@_pipeContractsSerializable
class SubscriptionEnvelope {
  /// Creates a new [SubscriptionEnvelope] instance.
  const SubscriptionEnvelope({
    required this.id,
    required this.topic,
    required this.topicType,
  });

  /// Creates a new [SubscriptionEnvelope] instance from a JSON object.
  factory SubscriptionEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionEnvelopeFromJson(json);

  /// Unique identifier for this subscription request.
  final String id;

  /// Topic data in JSON format.
  final Map<String, dynamic> topic;

  /// Full name of the topic type.
  final String topicType;

  /// Converts the subscription envelope to a JSON object.
  Map<String, dynamic> toJson() => _$SubscriptionEnvelopeToJson(this);

  @override
  String toString() =>
      'SubscriptionEnvelope(id: $id, topic: $topic, topicType: $topicType)';
}
