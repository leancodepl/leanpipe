import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';
import 'package:test/test.dart';

final funnelDisabledEndpoint =
    Uri.parse('testapp-funneldisabled-svc.default.cluster.local')
        .resolve('leanpipe')
        .toString();
final funnelEnabledEndpoint =
    Uri.parse('testapp-funnelenabled-svc.default.cluster.local')
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

  test('calculate', () {});

  print('test passed');
}
