import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';
import 'package:publisher_client_integration_tests/data/contracts.dart';
import 'package:test/test.dart';

const publisherHostEnvVarName = 'PUBLISHER_HOST';
const testAccessToken = '1234';

Future<void> _triggerNotification(Topic_ topic, String endpoint) {
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
      endpoint = switch (Platform.environment[publisherHostEnvVarName]) {
        final endpoint? => endpoint,
        _ => throw StateError(
            'Environment variable $publisherHostEnvVarName is not set',
          ),
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
    final topic = Topic_(topicId: '1');

    var received = false;

    await pipeClient.connect();

    final subscription = await pipeClient.subscribe(topic);

    final handlerSubscription = subscription.listen((_) => received = true);

    await _triggerNotification(topic, endpoint);

    await Future<void>.delayed(waitTime);

    expect(received, true);

    await handlerSubscription.cancel();
    await subscription.unsubscribe();
    await pipeClient.disconnect();
  });
}
