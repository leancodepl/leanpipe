import 'package:leancode_pipe/leancode_pipe/authorized_pipe_http_client.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';
import 'package:leancode_pipe/signalr_core/signalr_core.dart';

/// Creates a new SignalR hub connection configured for the pipe service.
///
/// [pipeUrl] - The URL of the pipe service endpoint
/// [tokenFactory] - Optional factory function to provide authentication tokens
///
/// The connection is configured with:
/// - WebSocket transport
/// - Automatic reconnection with exponential backoff
/// - Authorization via [AuthorizedPipeHttpClient] if [tokenFactory] is provided
HubConnection createHubConnection({
  required String pipeUrl,
  PipeTokenFactory? tokenFactory,
}) {
  return HubConnectionBuilder()
      .withUrl(
        pipeUrl,
        HttpConnectionOptions(
          client: AuthorizedPipeHttpClient(tokenFactory: tokenFactory),
          transport: HttpTransportType.webSockets,
        ),
      )
      .withAutomaticReconnect(
        DefaultReconnectPolicy(
          retryDelays: [0, 2000, 5000, 10000, 20000, 30000, null],
        ),
      )
      .build();
}
