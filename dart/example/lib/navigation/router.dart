import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'redirections.dart';
import 'routes.dart';

class _CubitNotifier extends ChangeNotifier {
  _CubitNotifier(this._cubit) {
    _cubit.stream.listen((state) {
      notifyListeners();
    });
  }

  final AuthCubit _cubit;

  AuthState get state => _cubit.state;
}

GoRouter createGoRouter(
  BuildContext context, {
  GlobalKey<NavigatorState>? navigatorKey,
  String? initialLocation,
}) {
  final authCubit = context.read<AuthCubit>();
  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: initialLocation ?? AuthRoute<void>().location,
    routes: $appRoutes,
    redirect: (context, state) => getRedirection(
      context,
      state.location,
      queryParams: state.queryParameters,
    ),
    refreshListenable: _CubitNotifier(authCubit),
  );
}
