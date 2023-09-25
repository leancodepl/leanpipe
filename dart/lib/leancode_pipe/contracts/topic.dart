abstract interface class Topic<Notification extends Object> {
  Notification? castNotification(String fullName, dynamic json);

  String getFullName();

  Map<String, dynamic> toJson();

  Topic<Notification> fromJson(Map<String, dynamic> json);
}
