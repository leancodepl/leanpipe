import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

typedef Redirection = String? Function(
  BuildContext context,
  String location, {
  Map<String, String>? queryParams,
});

String? getRedirection(
  BuildContext context,
  String location, {
  Map<String, String>? queryParams,
}) {
  final authCubit = context.read<AuthCubit>();
  final authState = authCubit.state;
  final isAuthenticated = authState is LoggedIn;

  final authenticatedRedirections = <Redirection>[];

  final redirections = <Redirection>[
    authStateRedirect,
    if (isAuthenticated) ...authenticatedRedirections,
  ];

  for (final redirection in redirections) {
    final newLocation = redirection(
      context,
      location,
      queryParams: queryParams,
    );
    if (newLocation != null && newLocation != location) {
      return newLocation;
    }
  }
  return null;
}

final _unauthenticatedRoutes = [
  RegisterRoute().location,
  VerifyRoute().location,
  LoginRoute().location,
  RecoveryRoute().location,
];

String? authStateRedirect(
  BuildContext context,
  String location, {
  Map<String, String>? queryParams,
}) {
  final locationWithoutQueryParams = location.split('?').first;
  final isUnauthenticatedRoute =
      _unauthenticatedRoutes.contains(locationWithoutQueryParams);

  final authCubit = context.read<AuthCubit>();
  final authState = authCubit.state;
  final isAuthenticated = authState is LoggedIn;

  if (isAuthenticated) {
    if (isUnauthenticatedRoute) {
      return HomeRoute().location;
    } else {
      return null;
    }
  } else {
    if (isUnauthenticatedRoute) {
      return null;
    } else {
      return LoginRoute().location;
    }
  }
}
