import 'package:app/app.dart';
import 'package:app/common/config/app_config.dart';
import 'package:app/common/widgets/global_providers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl_standalone.dart'
    if (dart.library.html) 'package:intl/intl_browser.dart';
import 'package:package_info_plus/package_info_plus.dart';

Future<void> mainCommon(AppConfig config) async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(await prepareApp(config));
}

Future<Widget> prepareApp(AppConfig config) async {
  Intl.defaultLocale = await findSystemLocale();
  return GlobalProviders(
    config: config,
    packageInfo: await PackageInfo.fromPlatform(),
    child: const App(),
  );
}
