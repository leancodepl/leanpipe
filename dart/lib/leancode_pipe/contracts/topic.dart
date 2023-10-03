abstract interface class Topic<Notification extends Object> {
  Notification? castNotification(String tag, dynamic json);

  String getFullName();

  Map<String, dynamic> toJson();

  Topic<Notification> fromJson(Map<String, dynamic> json);
}
