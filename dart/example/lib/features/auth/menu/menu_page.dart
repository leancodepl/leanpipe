import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:app/features/auth/kratos/dashboard/dashboard_cubit.dart';
import 'package:app/features/auth/menu/menu_cubit.dart';
import 'package:app/navigation/routes.dart';
import 'package:app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class MenuPage extends Page<void> {
  @override
  Route<void> createRoute(BuildContext context) => MenuPageRoute(this);
}

class MenuPageRoute extends MaterialPageRoute<void> {
  MenuPageRoute([MenuPage? page])
      : super(
          settings: page,
          builder: (context) => const MenuPageScreen(),
        );
}

class MenuPageScreen extends StatelessWidget {
  const MenuPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final menuCubit = context.read<MenuCubit>();

    return Scaffold(
      backgroundColor: context.colors.bgDefaultPrimary,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            HomeRoute().go(context);
          },
        ),
      ),
      body: BlocBuilder<MenuCubit, MenuState>(
        bloc: menuCubit,
        builder: (context, state) {
          return switch (state) {
            LoadingMenu _ => const Center(
                child: AppLoadingOverlay(
                  isLoading: true,
                ),
              ),
            final LoadedMenu state => _MenuBody(
                state: state,
              ),
            ErrorLoadingMenu _ => const Center(
                child: AppLoadingOverlay(
                  isLoading: true,
                ),
              ),
          };
        },
      ),
    );
  }
}

class _MenuBody extends HookWidget {
  const _MenuBody({required this.state});

  final LoadedMenu state;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);
    final colors = context.colors;

    final dashboardCubit = useBloc(
      () => DashboardCubit(
        kratosClient: context.read<KratosClient>(),
        authCubit: context.read<AuthCubit>(),
      ),
    );
    return SafeArea(
      child: Column(
        children: [
          ListTile(
            title: AppText(state.email ?? ''),
            subtitle: AppText('${state.givenName} ${state.familyName}'),
            leading: CircleAvatar(
              backgroundColor: colors.bgInfoPrimary,
              child: AppText(
                state.initials,
                style: AppTextStyle.caption,
                textAlign: TextAlign.center,
                color: colors.bgDefaultPrimary,
              ),
            ),
            onTap: () {
              ProfileRoute().go(context);
            },
          ),
          const AppDivider(),
          ListTile(
            title: AppText(s.profile_my_profile),
            leading: const Icon(Icons.account_circle),
            onTap: () {
              ProfileRoute().go(context);
            },
          ),
          const AppDivider(),
          const Spacer(),
          const AppDivider(),
          ListTile(
            title: AppText(s.profile_password_change),
            leading: const Icon(Icons.lock_reset),
            onTap: () {
              ChangePasswordRoute().go(context);
            },
          ),
          const AppDivider(),
          ListTile(
            title: AppText(s.profile_logout),
            leading: const Icon(Icons.logout),
            onTap: dashboardCubit.logout,
          ),
        ],
      ),
    );
  }
}
