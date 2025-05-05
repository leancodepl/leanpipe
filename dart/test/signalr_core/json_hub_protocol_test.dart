import 'package:leancode_pipe/signalr_core/signalr_core.dart';
import 'package:test/test.dart';

void main() {
  test('can read ping message', () {
    final payload = '{"type":6}${TextMessageFormat.recordSeparator}';
    final messages = JsonHubProtocol().parseMessages(payload, (_, __) {});
    expect(messages, equals([PingMessage()]));
  });

  test('can read completion message', () {
    final payload = '{"type":3,"invocationId":"0","result":{"data":"123"}}'
        '${TextMessageFormat.recordSeparator}';
    final messages = JsonHubProtocol().parseMessages(payload, (_, __) => {});
    expect(
      messages,
      equals([
        CompletionMessage(invocationId: '0', result: {'data': '123'}),
      ]),
    );
  });
}
