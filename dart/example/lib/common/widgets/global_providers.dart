import 'package:app/common/config/app_config.dart';
import 'package:app/common/config/app_global_keys.dart';
import 'package:app/common/util/use_global_key.dart';
import 'package:app/data/middlewares/error_handling_cqrs_middleware.dart';
import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:app/features/auth/kratos/di/providers.dart';
import 'package:app/features/employees_screen/bloc/employees_cubit.dart';
import 'package:cqrs/cqrs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';
import 'package:leancode_pipe/leancode_pipe/authorized_pipe_http_client.dart';
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
    final kratosProviders = useKratosProviders(kratosUri: config.kratosUri);

    return MultiProvider(
      providers: kratosProviders,
      child: _GlobalProviders(
        config: config,
        packageInfo: packageInfo,
        child: child,
      ),
    );
  }
}

class _GlobalProviders extends HookWidget {
  const _GlobalProviders({
    required this.config,
    required this.packageInfo,
    required this.child,
  });

  final AppConfig config;
  final PackageInfo packageInfo;
  final Widget child;

  Future<String> getToken(BuildContext context) async {
    final credentials =
        await context.read<FlutterSecureCredentialsStorage>().read();

    return credentials ?? '';
  }

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

    final authState = context.watch<AuthCubit>();

    final accessTokenFuture = useMemoized(
      () => context.read<FlutterSecureCredentialsStorage>().read(),
      [authState],
    );

    final accessToken = useFuture(
      accessTokenFuture,
      preserveState: false,
    ).data;

    final httpClient = useMemoized(
      () => AuthorizedPipeHttpClient(
        tokenFactory: () => getToken(context),
      ),
      [accessToken],
    );

    final cqrs = useMemoized(
      () => Cqrs(
        httpClient,
        config.apiUri,
        logger: Logger('Cqrs'),
        middlewares: [
          ErrorHandlingCqrsMiddleware(
            navigatorKey,
            scaffoldMessengerKey,
          ),
        ],
      ),
      [httpClient, config],
    );

    final pipeClient = PipeClient(
      pipeUrl: config.pipeUri.toString(),
      tokenFactory: () => getToken(context),
    );

    final employeesCubit = useMemoized(() => EmployeesCubit(cqrs: cqrs));

    return MultiProvider(
      providers: [
        Provider.value(value: globalKeys),
        Provider.value(value: config),
        Provider.value(value: cqrs),
        Provider.value(value: httpClient),
        Provider.value(value: pipeClient),
        BlocProvider.value(value: employeesCubit),
      ],
      child: child,
    );
  }
}