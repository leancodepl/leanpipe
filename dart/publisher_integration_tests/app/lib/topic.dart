import 'package:leancode_pipe/leancode_pipe/contracts/topic.dart' as leanpipe;

class Topic implements leanpipe.Topic<NotificationDTO> {
  const Topic({required this.id});

  final String id;

  @override
  NotificationDTO? castNotification(String tag, json) {
    throw UnimplementedError();
  }

  @override
  leanpipe.Topic<NotificationDTO> fromJson(Map<String, dynamic> json) {
    return Topic(id: json['topicId']);
  }

  @override
  String getFullName() {
    // TODO: implement getFullName
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic> toJson() {
    return {'topicId': id};
  }
}

class NotificationDTO {}
