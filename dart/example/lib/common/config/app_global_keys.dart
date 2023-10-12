import 'package:flutter/material.dart' show ScaffoldMessengerState;
import 'package:flutter/widgets.dart';

class AppGlobalKeys {
  const AppGlobalKeys({
    required this.navigatorKey,
    required this.scaffoldMessengerKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey;
}
