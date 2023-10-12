import 'package:app/common/config/app_config.dart';
import 'package:app/common/config/app_global_keys.dart';
import 'package:app/common/util/use_global_key.dart';
import 'package:app/features/auth/kratos/di/providers.dart';
import 'package:cqrs/cqrs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'package:leancode_kratos_client/leancode_kratos_client.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

class GlobalProviders extends HookWidget {
  const GlobalProviders({
    super.key,
    required this.config,
    required this.packageInfo,
    required this.child,
  });

  final AppConfig config;
  final PackageInfo packageInfo;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final navigatorKey = useGlobalKey<NavigatorState>();
    final scaffoldMessengerKey = useGlobalKey<ScaffoldMessengerState>();
    final globalKeys = useMemoized(
      () => AppGlobalKeys(
        navigatorKey: navigatorKey,
        scaffoldMessengerKey: scaffoldMessengerKey,
      ),
    );

    final httpClient = useMemoized(
      http.Client.new,
      const [],
    );

    final cqrs = useMemoized(
      () => Cqrs(
        httpClient,
        config.apiUri,
        logger: Logger('Cqrs'),
      ),
      const [],
    );

    final pipeClient = PipeClient(
      pipeUrl: config.pipeUri.toString(),
      tokenFactory: () async {
        final credentials =
            await context.read<FlutterSecureCredentialsStorage>().read();

        return credentials ?? '';
      },
    );

    return MultiProvider(
      providers: [
        Provider.value(value: globalKeys),
        Provider.value(value: config),
        Provider.value(value: cqrs),
        Provider.value(value: httpClient),
        ...useKratosProviders(
          kratosUri: config.kratosUri,
          httpClient: httpClient,
        ),
        Provider.value(value: pipeClient),
      ],
      child: child,
    );
  }
}
