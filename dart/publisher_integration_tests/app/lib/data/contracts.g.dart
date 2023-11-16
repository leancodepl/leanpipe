// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contracts.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthConfig _$AuthConfigFromJson(Map<String, dynamic> json) => AuthConfig();

Map<String, dynamic> _$AuthConfigToJson(AuthConfig instance) =>
    <String, dynamic>{};

KnownClaims _$KnownClaimsFromJson(Map<String, dynamic> json) => KnownClaims();

Map<String, dynamic> _$KnownClaimsToJson(KnownClaims instance) =>
    <String, dynamic>{};

Roles _$RolesFromJson(Map<String, dynamic> json) => Roles();

Map<String, dynamic> _$RolesToJson(Roles instance) => <String, dynamic>{};

NotificationDTO _$NotificationDTOFromJson(Map<String, dynamic> json) =>
    NotificationDTO(
      greeting: json['Greeting'] as String,
    );

Map<String, dynamic> _$NotificationDTOToJson(NotificationDTO instance) =>
    <String, dynamic>{
      'Greeting': instance.greeting,
    };

Topic_ _$Topic_FromJson(Map<String, dynamic> json) => Topic_(
      topicId: json['TopicId'] as String,
    );

Map<String, dynamic> _$Topic_ToJson(Topic_ instance) => <String, dynamic>{
      'TopicId': instance.topicId,
    };
