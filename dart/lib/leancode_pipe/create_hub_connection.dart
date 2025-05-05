import 'package:leancode_pipe/leancode_pipe/authorized_pipe_http_client.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';
import 'package:leancode_pipe/signalr_core/signalr_core.dart';

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
