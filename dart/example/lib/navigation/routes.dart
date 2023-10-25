import 'package:app/data/contracts.dart';
import 'package:app/features/assignment_screen/assignment_screen.dart';
import 'package:app/features/auth/auth_init_page/auth_init_page.dart';
import 'package:app/features/auth/login/login_page.dart';
import 'package:app/features/auth/register/register_page.dart';
import 'package:app/features/auth/verification/verification_page.dart';
import 'package:app/features/employees_screen/employees_screen.dart';
import 'package:app/features/home/home_screen.dart';
import 'package:app/features/project_details_screen/project_details_screen.dart';
import 'package:app/features/projects_screen/projects_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

abstract class PlatformGoRouteData<T> extends GoRouteData {
  const PlatformGoRouteData({this.pageKey});

  final LocalKey? pageKey;

  @override
  Page<T> buildPage(BuildContext context, GoRouterState state) {
    return _buildAppPage(
      key: pageKey,
      child: build(context, state),
    );
  }
}

const _homePageKey = ValueKey('HomePage');
const _authPageKey = ValueKey('AuthPage');

@TypedGoRoute<HomeRoute>(path: '/')
class HomeRoute extends PlatformGoRouteData<void> {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const HomePage(key: _homePageKey);
}

@TypedGoRoute<AssignmentRoute>(path: '/assignment')
class AssignmentRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    return AssignmentPage(
      projectId: state.queryParameters['projectId']!,
      assignmentDTO: state.extra! as AssignmentDTO,
    );
  }
}

@TypedGoRoute<EmployeesRoute>(path: '/employees')
class EmployeesRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const EmployeesPage();
}

@TypedGoRoute<ProjectsRoute>(path: '/projects')
class ProjectsRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      const ProjectsPage();
}

@TypedGoRoute<ProjectDetailsRoute>(path: '/project-details')
class ProjectDetailsRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final projectId = state.queryParameters['projectId'];

    return ProjectDetailsPage(projectId: projectId);
  }
}

@TypedShellRoute<RootRoute>(
  routes: [
    TypedGoRoute<HomeRoute>(path: '/'),
    TypedGoRoute<AuthRoute<void>>(
      path: '/auth',
      routes: [
        TypedGoRoute<RegisterRoute>(path: 'register'),
        TypedGoRoute<VerifyRoute>(path: 'verify'),
        TypedGoRoute<LoginRoute>(path: 'login'),
      ],
    ),
  ],
)
class RootRoute extends ShellRouteData {
  @override
  Widget builder(BuildContext context, GoRouterState state, Widget navigator) {
    return navigator;
  }
}

class AuthRoute<T> extends PlatformGoRouteData<T> {
  @override
  Page<T> buildPage(BuildContext context, GoRouterState state) {
    return MaterialPage<T>(
      key: _authPageKey,
      child: const AuthInitPage(),
    );
  }
}

class RegisterRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      RegisterPage();
}

class LoginRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) =>
      LoginPage();
}

class VerifyRoute extends GoRouteData {
  @override
  Page<void> buildPage(BuildContext context, GoRouterState state) {
    final email = state.queryParameters['email'];
    final flowId = state.queryParameters['flowId'];
    final code = state.queryParameters['code'];

    return VerifyCodePage(
      email: email,
      flowId: flowId,
      code: code,
    );
  }
}

Page<T> _buildAppPage<T>({
  LocalKey? key,
  required Widget child,
}) {
  if (kIsWeb) {
    return NoTransitionPage<T>(
      key: key,
      child: child,
    );
  } else {
    return MaterialPage<T>(
      key: key,
      child: child,
    );
  }
}
