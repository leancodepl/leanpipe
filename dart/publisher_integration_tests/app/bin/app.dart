import 'dart:convert';
import 'dart:io';

import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';
import 'package:publisher_client_integration_tests/topic.dart';
import 'package:test/test.dart';
import 'package:http/http.dart' as http;

// final funnelDisabledEndpoint =
//     Uri.parse('http://testapp-funneldisabled-svc.default.svc.cluster.local/')
//         .resolve('leanpipe')
//         .toString();
// final funnelDisabledEndpoint = 'http://localhost:5151/leanpipe';
// final funnelDisabledPostEndpoint = 'http://localhost:5151/publish';
// final funnelEnabledEndpoint = Uri.parse(
//         'localhost:8080/testapp-funnelenabled-svc.default.svc.cluster.local')
//     .resolve('leanpipe')
//     .toString();

const testAccessToken = '1234';

Future<void> _triggerNotification(Topic topic, String endpoint) {
  final body = jsonEncode(topic.toJson());

  return http.post(
    Uri.parse(endpoint).resolve('publish'),
    headers: {'Content-Type': 'application/json'},
    body: body,
  );
}

void main() {
  late PipeClient pipeClient;
  late String endpoint;

  setUp(
    () {
      const envVarName = 'TEST_ENDPOINT';
      endpoint = switch (Platform.environment[envVarName]) {
        final endpoint? => endpoint,
        _ => throw StateError('Environment variable $envVarName is not set'),
      };

      pipeClient = PipeClient(
        pipeUrl: Uri.parse(endpoint).resolve('leanpipe').toString(),
        tokenFactory: () async => testAccessToken,
      );
    },
  );

  test(
      'Basic scenario: connect, subscribe, trigger notification, receive notification, unsubscribe, trigger notification, make sure nothing is received, cancel subscriptions, disconnect',
      () async {
    const waitTime = Duration(seconds: 1);
    const topic = Topic(id: '1');

    bool received = false;

    await pipeClient.connect();

    final subscription = await pipeClient.subscribe(topic);

    final handlerSubscription = subscription.listen((value) {
      received = true;
    });

    await _triggerNotification(topic, endpoint);

    await Future.delayed(waitTime);

    expect(received, true);

    await subscription.unsubscribe();
    received = false;

    await _triggerNotification(topic, endpoint);

    await Future.delayed(waitTime);

    expect(received, false);

    await handlerSubscription.cancel();
    await pipeClient.disconnect();
  });
}
