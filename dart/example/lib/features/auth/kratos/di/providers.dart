import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:http/http.dart' as http;
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

List<SingleChildWidget> useKratosProviders({
  required Uri kratosUri,
  http.Client? httpClient,
}) {
  final kratosClient = useMemoized(
    () => KratosClient(
      baseUri: kratosUri,
      httpClient: httpClient,
      browserCallback: (url) => FlutterWebAuth2.authenticate(
        url: url,
        callbackUrlScheme: 'pl.leancode.template.tst',
      ),
    ),
    const [],
  );

  final kratosSecureStorage = useMemoized(FlutterSecureCredentialsStorage.new);

  final authCubit = useMemoized(
    () => AuthCubit(
      storage: kratosSecureStorage,
      kratosClient: kratosClient,
    ),
    [],
  );

  return [
    Provider.value(value: kratosSecureStorage),
    Provider.value(value: kratosClient),
    BlocProvider.value(value: authCubit),
  ];
}
