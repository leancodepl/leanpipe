import 'package:http/http.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

const webSocketChannelImplementation = 'web';

Future<WebSocketChannel> connect(Uri uri, {BaseClient? client}) async =>
    Future.value(WebSocketChannel.connect(uri));
