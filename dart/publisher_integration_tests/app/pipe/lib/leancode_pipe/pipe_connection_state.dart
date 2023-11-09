/// Describes the current state of the connection to the server.
enum PipeConnectionState {
  /// The pipe connection is disconnected.
  disconnected,

  /// The pipe connection is connecting.
  connecting,

  /// The pipe connection is connected.
  connected,

  /// The pipe connection is disconnecting.
  disconnecting,

  /// The pipe connection is reconnecting.
  reconnecting
}
