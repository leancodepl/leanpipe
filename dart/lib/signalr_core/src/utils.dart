import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:leancode_pipe/signalr_core/src/logger.dart';

typedef OnReceive = void Function(dynamic data);
typedef OnClose = void Function(Exception? error);
typedef AccessTokenFactory = Future<String?> Function();
typedef Logging = void Function(LogLevel level, String message);

const String version = '0.0.0-DEV_BUILD';

String getDataDetail(dynamic data, bool? includeContent) {
  var detail = '';

  if (data is ByteBuffer) {
    detail = 'Binary data of length ${data.lengthInBytes}';
    if (includeContent!) {
      detail += '. Content: \'${formatByteBuffer(data)}\'';
    }
  } else if (data is String) {
    detail = 'String data of length \'${data.length}\'';
    if (includeContent!) {
      detail += '. Content: \'$data\'';
    }
  }

  return detail;
}

String formatByteBuffer(ByteBuffer data) {
  final view = data.asUint8List();

  var str = '';
  for (var n in view) {
    final pad = n < 16 ? '0' : '';
    str += '0x$pad${n.toStringAsFixed(16)} ';
  }

  return str.substring(0, str.length - 1);
}

Future<void> sendMessage(
    Logging? log,
    String transportName,
    BaseClient? client,
    String? url,
    AccessTokenFactory? accessTokenFactory,
    dynamic content,
    bool? logMessageContent,
    bool? withCredentials) async {
  var headers = <String, String>{};
  if (accessTokenFactory != null) {
    final token = await accessTokenFactory();
    if (token != null) {
      headers = {
        'Authorization': 'Bearer $token',
      };
    }
  }

  final userAgentHeader = getUserAgentHeader();
  headers[userAgentHeader.$1] = userAgentHeader.$2;

  log?.call(
    LogLevel.trace,
    '($transportName transport) sending data. '
    '${getDataDetail(content, logMessageContent)}.',
  );

  final encoding = (content is ByteBuffer)
      ? Encoding.getByName('')
      : Encoding.getByName('UTF-8');
  final response = await client?.post(Uri.parse(url ?? ''),
      headers: headers, body: content, encoding: encoding);

  log?.call(
    LogLevel.trace,
    '($transportName transport) request complete. Response status: '
    '${response?.statusCode}.',
  );
}

(String, String) getUserAgentHeader() {
  var userAgentHeaderName = 'X-SignalR-User-Agent';
  return (
    userAgentHeaderName,
    _constructUserAgent(
      version,
      getOsName(),
      getRuntime(),
      getRuntimeVersion(),
    )
  );
}

String _constructUserAgent(
  String version,
  String os,
  String runtime,
  String runtimeVersion,
) {
  // Microsoft SignalR/[Version] ([Detailed Version]; [Operating System];
  //[Runtime]; [Runtime Version])
  var userAgent = 'Microsoft SignalR/';

  final majorAndMinor = version.split('.');
  userAgent += '${majorAndMinor[0]}.${majorAndMinor[1]}';
  userAgent += ' ($version; ';

  if (os.isNotEmpty) {
    userAgent += '$os; ';
  } else {
    userAgent += 'Unknown OS; ';
  }

  userAgent += runtime;

  if (runtimeVersion.isNotEmpty) {
    userAgent += '; $runtimeVersion';
  } else {
    userAgent += '; Unknown Runtime Version';
  }

  userAgent += ')';
  return userAgent;
}

String getOsName() {
  // TODO: Figure out to determine the platform without using dart:io
  return '';
}

String getRuntimeVersion() {
  return '';
}

String getRuntime() {
  return '';
}
