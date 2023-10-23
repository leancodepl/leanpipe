import 'package:http/http.dart' as http;
import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';

class PipeAuthorizedHttpClient extends http.BaseClient {
  PipeAuthorizedHttpClient({
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
