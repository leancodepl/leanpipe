import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/// Marks which platform implementation of [connect] got selected by the
/// conditional import in `web_socket_transport.dart`.
const webSocketChannelImplementation = 'unsupported';

Future<WebSocketChannel> connect(Uri uri, {BaseClient? client}) => Future.error(
    UnsupportedError('No implementation of the connect api provided'));
