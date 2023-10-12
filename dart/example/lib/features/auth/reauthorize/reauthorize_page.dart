import 'package:app/design_system_old/app_design_system.dart';
import 'package:app/design_system_old/widgets/app_text_form_field.dart';
import 'package:app/features/auth/kratos/common/kratos_errors.dart';
import 'package:app/features/auth/kratos/common/validators.dart';
import 'package:app/features/auth/menu/menu_cubit.dart';
import 'package:app/features/auth/reauthorize/reauthorize_cubit.dart';
import 'package:app/features/auth/social/social_cubit.dart';
import 'package:app/resources/strings.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class ReauthorizePage extends Page<void> {
  @override
  Route<void> createRoute(BuildContext context) => ReauthorizePageRoute(this);
}

class ReauthorizePageRoute extends MaterialPageRoute<void> {
  ReauthorizePageRoute([ReauthorizePage? page])
      : super(
          settings: page,
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => ReauthorizeCubit(
                  kratosClient: context.read(),
                ),
              ),
              BlocProvider(
                create: (context) => SocialCubit(
                  kratosClient: context.read(),
                  authCubit: context.read(),
                ),
              ),
            ],
            child: const ReauthorizeScreen(),
          ),
        );
}

class ReauthorizeScreen extends HookWidget {
  const ReauthorizeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    useBlocPresentationListener<SocialCubit, SocialEvent>(
      listener: (context, event) => switch (event) {
        SocialSuccessEvent() => context.pop(true),
        _ => () {}
      },
    );

    useBlocPresentationListener<ReauthorizeCubit, ReauthorizeCubitEvent>(
      listener: (context, event) => switch (event) {
        ReauthorizeSuccess() => context.pop(true),
        _ => () {}
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: AppText(s.reauthorize_title),
        automaticallyImplyLeading: false,
      ),
      body: const ReauthorizeBody(),
    );
  }
}

class ReauthorizeBody extends HookWidget {
  const ReauthorizeBody({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final showInfo = useState<bool>(true);

    return switch (showInfo.value) {
      true => InfoScreen(
          showInfo: showInfo,
        ),
      false => const ReauthorizeForm(),
    };
  }
}

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key, required this.showInfo});

  final ValueNotifier<bool> showInfo;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText(
            s.reauthorize_info,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          AppPrimaryButton(
            label: s.reauthorize_info_button,
            onPressed: () {
              showInfo.value = false;
            },
          ),
        ],
      ),
    );
  }
}

class ReauthorizeForm extends HookWidget {
  const ReauthorizeForm({super.key});

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    final formKey = useMemoized(GlobalKey<FormState>.new);

    final passwordController = useTextEditingController();

    final cubit = context.watch<ReauthorizeCubit>();
    final menuCubit = context.watch<MenuCubit>();
    final email = menuCubit.email ?? '';
    final socialCubit = context.watch<SocialCubit>();

    final state = cubit.state;

    void login() {
      if (formKey.currentState?.validate() ?? false) {
        final password = passwordController.text;
        cubit.reauthorizeWithPassword(email: email, password: password);
      }
    }

    final error = state.error;

    return WillPopScope(
      onWillPop: () async => false,
      child: AppLoadingOverlay(
        isLoading: state.inProgress,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                AppPrimaryButton(
                  label: s.login_with_apple_button,
                  onPressed: () =>
                      socialCubit.registerWithOidc(OidcProvider.apple),
                ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  label: s.login_with_google_button,
                  onPressed: () =>
                      socialCubit.registerWithOidc(OidcProvider.google),
                ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  label: s.login_with_facebook_button,
                  onPressed: () =>
                      socialCubit.registerWithOidc(OidcProvider.facebook),
                ),
                const SizedBox(height: 16),
                AppTextFormField(
                  controller: passwordController,
                  label: AppText(s.password_field),
                  validator: (text) => validateEmptyField(context, text),
                  obscureText: true,
                  autocorrect: false,
                ),
                const SizedBox(height: 16),
                AppPrimaryButton(
                  label: s.login_button,
                  onPressed: login,
                ),
                const SizedBox(height: 16),
                if (error != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: AppText(
                      switch (error) {
                        LoginUnknownError() => s.login_unknown_error,
                        LoginKratosError(error: final error) =>
                          error.localized(context),
                      },
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
