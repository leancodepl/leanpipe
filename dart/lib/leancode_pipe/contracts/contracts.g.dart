// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contracts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubscriptionResult _$SubscriptionResultFromJson(Map<String, dynamic> json) =>
    SubscriptionResult(
      subscriptionId: json['SubscriptionId'] as String,
      status: $enumDecode(_$SubscriptionStatusEnumMap, json['Status']),
      type: $enumDecode(_$OperationTypeEnumMap, json['Type']),
    );

Map<String, dynamic> _$SubscriptionResultToJson(SubscriptionResult instance) =>
    <String, dynamic>{
      'SubscriptionId': instance.subscriptionId,
      'Status': _$SubscriptionStatusEnumMap[instance.status]!,
      'Type': _$OperationTypeEnumMap[instance.type]!,
    };

const _$SubscriptionStatusEnumMap = {
  SubscriptionStatus.success: 0,
  SubscriptionStatus.unauthorized: 1,
  SubscriptionStatus.malformed: 2,
  SubscriptionStatus.invalid: 3,
  SubscriptionStatus.internalServerError: 4,
};

const _$OperationTypeEnumMap = {
  OperationType.subscribe: 0,
  OperationType.unsubscribe: 1,
};

NotificationEnvelope _$NotificationEnvelopeFromJson(
        Map<String, dynamic> json) =>
    NotificationEnvelope(
      id: json['Id'] as String,
      topicType: json['TopicType'] as String,
      notificationType: json['NotificationType'] as String,
      topic: json['Topic'] as Map<String, dynamic>,
      notification: json['Notification'] as Object,
    );

Map<String, dynamic> _$NotificationEnvelopeToJson(
        NotificationEnvelope instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'TopicType': instance.topicType,
      'NotificationType': instance.notificationType,
      'Topic': instance.topic,
      'Notification': instance.notification,
    };

SubscriptionEnvelope _$SubscriptionEnvelopeFromJson(
        Map<String, dynamic> json) =>
    SubscriptionEnvelope(
      id: json['Id'] as String,
      topic: json['Topic'] as String,
      topicType: json['TopicType'] as String,
    );

Map<String, dynamic> _$SubscriptionEnvelopeToJson(
        SubscriptionEnvelope instance) =>
    <String, dynamic>{
      'Id': instance.id,
      'Topic': instance.topic,
      'TopicType': instance.topicType,
    };
