// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
import 'package:leancode_contracts/leancode_contracts.dart';
import 'package:leancode_pipe/leancode_pipe.dart';
part 'contracts.g.dart';

@ContractsSerializable()
class AuthConfig with EquatableMixin {
  AuthConfig();

  factory AuthConfig.fromJson(Map<String, dynamic> json) =>
      _$AuthConfigFromJson(json);

  List<Object?> get props => [];

  Map<String, dynamic> toJson() => _$AuthConfigToJson(this);
}

@ContractsSerializable()
class KnownClaims with EquatableMixin {
  KnownClaims();

  factory KnownClaims.fromJson(Map<String, dynamic> json) =>
      _$KnownClaimsFromJson(json);

  static const String userId = 'sub';

  static const String role = 'role';

  List<Object?> get props => [];

  Map<String, dynamic> toJson() => _$KnownClaimsToJson(this);
}

@ContractsSerializable()
class Roles with EquatableMixin {
  Roles();

  factory Roles.fromJson(Map<String, dynamic> json) => _$RolesFromJson(json);

  static const String user = 'user';

  List<Object?> get props => [];

  Map<String, dynamic> toJson() => _$RolesToJson(this);
}

@ContractsSerializable()
class NotificationDTO with EquatableMixin implements TopicNotification {
  NotificationDTO({required this.greeting});

  factory NotificationDTO.fromJson(Map<String, dynamic> json) =>
      _$NotificationDTOFromJson(json);

  final String greeting;

  List<Object?> get props => [greeting];

  Map<String, dynamic> toJson() => _$NotificationDTOToJson(this);
}

/// LeanCode.Contracts.Security.AuthorizeWhenHasAnyOfAttribute('user')
@ContractsSerializable()
class Topic_ with EquatableMixin implements Topic<TopicNotification> {
  Topic_({required this.topicId});

  factory Topic_.fromJson(Map<String, dynamic> json) => _$Topic_FromJson(json);

  final String topicId;

  List<Object?> get props => [topicId];

  Map<String, dynamic> toJson() => _$Topic_ToJson(this);

  TopicNotification? castNotification(
    String tag,
    dynamic json,
  ) =>
      switch (tag) {
        'LeanCode.Pipe.ClientIntegrationTestsApp.Contracts.NotificationDTO' =>
          _$NotificationDTOFromJson(json as Map<String, dynamic>),
        _ => null
      } as TopicNotification?;

  Topic_ fromJson(Map<String, dynamic> json) => Topic_.fromJson(json);

  String getFullName() =>
      'LeanCode.Pipe.ClientIntegrationTestsApp.Contracts.Topic';
}

sealed class TopicNotification {}
