import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:app/features/auth/menu/menu_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_hooks/leancode_hooks.dart';

class AuthInitPage extends HookWidget {
  const AuthInitPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.watch<AuthCubit>();
    final menuCubit = context.read<MenuCubit>();

    useEffect(
      () {
        authCubit.init();
        return;
      },
      [],
    );

    useEffect(
      () {
        if (authCubit.state is LoggedIn) {
          menuCubit.getSettings();
        }
        return;
      },
      [authCubit.state],
    );

    return BlocBuilder<AuthCubit, AuthState>(
      bloc: authCubit,
      builder: (context, state) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
