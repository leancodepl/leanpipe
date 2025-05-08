/// Represents a topic that can be subscribed to for receiving notifications.
///
/// A topic is a source of typed notifications that clients can subscribe to.
/// Each topic has a specific [Notification] type that it emits.
abstract interface class Topic<Notification extends Object> {
  /// Attempts to cast a JSON notification to the correct [Notification] type.
  Notification? castNotification(String tag, dynamic json);

  /// Returns the fully qualified name of this topic type.
  String getFullName();

  /// Converts this topic to a JSON representation.
  Map<String, dynamic> toJson();

  /// Creates a new instance of this topic from JSON data.
  Topic<Notification> fromJson(Map<String, dynamic> json);
}
