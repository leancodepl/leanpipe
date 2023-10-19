import 'package:http/http.dart' as http;

class PrintingClient extends http.BaseClient {
  PrintingClient(this.client);

  final http.Client client;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    print('SENDING ${request.url}');
    return client.send(request);
  }
}
