import 'package:json_annotation/json_annotation.dart';

part 'contracts.g.dart';

const _pipeContractsSerializable = JsonSerializable(
  fieldRename: FieldRename.pascal,
);

@_pipeContractsSerializable
class SubscriptionResult {
  const SubscriptionResult({
    required this.subscriptionId,
    required this.status,
    required this.type,
  });

  factory SubscriptionResult.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionResultFromJson(json);

  final String subscriptionId;
  final SubscriptionStatus status;
  final OperationType type;

  Map<String, dynamic> toJson() => _$SubscriptionResultToJson(this);
}

enum SubscriptionStatus {
  @JsonValue(0)
  success,
  @JsonValue(1)
  unauthorized,
  @JsonValue(2)
  malformed,
  @JsonValue(3)
  invalid,
  @JsonValue(4)
  internalServerError,
}

enum OperationType {
  @JsonValue(0)
  subscribe,
  @JsonValue(1)
  unsubscribe,
}

@_pipeContractsSerializable
class NotificationEnvelope {
  const NotificationEnvelope({
    required this.id,
    required this.topicType,
    required this.notificationType,
    required this.topic,
    required this.notification,
  });

  factory NotificationEnvelope.fromJson(Map<String, dynamic> json) =>
      _$NotificationEnvelopeFromJson(json);

  final String id;
  final String topicType;
  final String notificationType;
  final Map<String, dynamic> topic;
  final Object notification;

  Map<String, dynamic> toJson() => _$NotificationEnvelopeToJson(this);

  @override
  String toString() {
    return 'NotificationEnvelope(id: $id, topicType: $topicType, notificationType: $notificationType, topic: $topic, notification: $notification)';
  }
}

@_pipeContractsSerializable
class SubscriptionEnvelope {
  const SubscriptionEnvelope({
    required this.id,
    required this.topic,
    required this.topicType,
  });

  factory SubscriptionEnvelope.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionEnvelopeFromJson(json);

  final String id;
  final String topic;
  final String topicType;

  Map<String, dynamic> toJson() => _$SubscriptionEnvelopeToJson(this);

  @override
  String toString() =>
      'SubscriptionEnvelope(id: $id, topic: $topic, topicType: $topicType)';
}
