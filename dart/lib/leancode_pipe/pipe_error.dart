/// Thrown when there is an error establishing or maintaining the pipe connection.
class PipeConnectionException implements Exception {
  /// Creates a new [PipeConnectionException].
  const PipeConnectionException();
}

/// Thrown when the pipe fails to reconnect after a connection loss.
class PipeReconnectException implements Exception {
  /// Creates a new [PipeReconnectException].
  const PipeReconnectException();
}

/// Thrown when the pipe connection is rejected due to invalid or missing authentication.
class PipeUnauthorizedException implements Exception {
  /// Creates a new [PipeUnauthorizedException].
  const PipeUnauthorizedException();
}

/// Thrown when the pipe server encounters an internal error.
class PipeServerException implements Exception {
  /// Creates a new [PipeServerException].
  const PipeServerException();
}
