import 'package:leancode_pipe/leancode_pipe/contracts/topic.dart' as leanpipe;

class Topic implements leanpipe.Topic<NotificationDTO> {
  const Topic({required this.id});

  final String id;

  @override
  NotificationDTO? castNotification(String tag, json) {
    return NotificationDTO(greeting: json['Greeting']);
  }

  @override
  leanpipe.Topic<NotificationDTO> fromJson(Map<String, dynamic> json) {
    return Topic(id: json['TopicId']);
  }

  @override
  String getFullName() => 'LeanCode.Pipe.ClientIntegrationTestsApp.Topic';

  @override
  Map<String, dynamic> toJson() {
    return {'TopicId': id};
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Topic && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class NotificationDTO {
  const NotificationDTO({required this.greeting});

  factory NotificationDTO.fromJson(Map<String, dynamic> json) =>
      NotificationDTO(greeting: json['Greeting']);

  final String greeting;

  Map<String, dynamic> toJson() => {'Greeting': greeting};
}
