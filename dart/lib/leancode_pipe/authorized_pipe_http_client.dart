import 'package:http/http.dart' as http;
import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';

/// An HTTP client that automatically adds authorization headers to requests.
///
/// Uses a `tokenFactory` to obtain Bearer tokens which are added to each request's
/// Authorization header. If no `tokenFactory` is provided, requests are sent without
/// authorization.
class AuthorizedPipeHttpClient extends http.BaseClient {
  /// Creates a new [AuthorizedPipeHttpClient].
  AuthorizedPipeHttpClient({
    http.Client? client,
    required PipeTokenFactory? tokenFactory,
  })  : _client = client ?? http.Client(),
        _tokenFactory = tokenFactory;

  final http.Client _client;
  final PipeTokenFactory? _tokenFactory;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (_tokenFactory case final tokenFactory?) {
      final accessToken = await tokenFactory();
      request.headers.addEntries(
        [MapEntry('Authorization', 'Bearer $accessToken')],
      );
    }

    return _client.send(request);
  }
}
