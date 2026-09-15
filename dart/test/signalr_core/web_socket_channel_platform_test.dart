import 'package:leancode_pipe/signalr_core/src/transports/web_socket_channel_api.dart'
    if (dart.library.js_interop) 'package:leancode_pipe/signalr_core/src/transports/web_socket_channel_web.dart'
    if (dart.library.io) 'package:leancode_pipe/signalr_core/src/transports/web_socket_channel_io.dart'
    as platform;
import 'package:test/test.dart';

void main() {
  // Guards the conditional import in
  // `lib/signalr_core/src/transports/web_socket_transport.dart`. It used to key
  // off `dart.library.html`, which is false under dart2wasm, so
  // `flutter build web --wasm` builds fell through to the unsupported stub and
  // could not open a WebSocket at all. Run this on `-p vm`, on `-p chrome` and
  // on `-p chrome --compiler dart2wasm`.
  test('a real WebSocket implementation is selected on this platform', () {
    expect(
      platform.webSocketChannelImplementation,
      isNot('unsupported'),
      reason: 'The conditional import fell through to the stub in '
          'web_socket_channel_api.dart, so WebSocket connections would throw '
          'UnsupportedError at runtime.',
    );
  });
}
