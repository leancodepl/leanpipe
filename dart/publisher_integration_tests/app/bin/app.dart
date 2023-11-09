import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';
import 'package:publisher_client_integration_tests/topic.dart';
import 'package:test/test.dart';

final funnelDisabledEndpoint =
    Uri.parse('http://testapp-funneldisabled-svc.default.svc.cluster.local/')
        .resolve('leanpipe')
        .toString();
final funnelEnabledEndpoint = Uri.parse(
        'localhost:8080/testapp-funnelenabled-svc.default.svc.cluster.local')
    .resolve('leanpipe')
    .toString();

const testAccessToken = '1234';

void main() {
  late PipeClient pipeClient;

  setUpAll(
    () {
      pipeClient = PipeClient(
        pipeUrl: funnelDisabledEndpoint,
        tokenFactory: () async => testAccessToken,
      );
    },
  );

  test('subscribe', () async {
    await pipeClient.connect();

    await pipeClient.subscribe(Topic(id: '1'));
  });

  print('test passed');
}
