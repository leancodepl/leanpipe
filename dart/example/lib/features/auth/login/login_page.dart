import 'package:app/design_system_old/app_design_system.dart';
import 'package:app/design_system_old/widgets/app_text_form_field.dart';
import 'package:app/features/auth/kratos/common/kratos_errors.dart';
import 'package:app/features/auth/kratos/common/multi_validator.dart';
import 'package:app/features/auth/kratos/common/validators.dart';
import 'package:app/features/auth/login/login_cubit.dart';
import 'package:app/features/auth/social/social_cubit.dart';
import 'package:app/features/auth/social/social_traits_form.dart';
import 'package:app/navigation/routes.dart';
import 'package:app/resources/strings.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class LoginPage extends Page<void> {
  @override
  Route<void> createRoute(BuildContext context) => MaterialPageRoute<void>(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => LoginCubit(
                kratosClient: context.read(),
                authCubit: context.read(),
              ),
            ),
            BlocProvider(
              create: (context) => SocialCubit(
                kratosClient: context.read(),
                authCubit: context.read(),
              ),
            ),
          ],
          child: const _LoginScreen(),
        ),
        settings: this,
      );
}

class _LoginScreen extends HookWidget {
  const _LoginScreen();

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    final socialState = context.watch<SocialCubit>().state;

    void navigateToEmailVerification(String? email, String? flowId) {
      context.go(
        Uri(
          path: VerifyRoute().location,
          queryParameters: {
            'email': email,
            'flowId': flowId,
          },
        ).toString(),
      );
    }

    useBlocPresentationListener<LoginCubit, LoginEvent>(
      listener: (context, event) => switch (event) {
        LoginSuccessEvent() => context.go(HomeRoute().location),
        LoginVerifyEmailEvent(
          email: final email,
          flowId: final flowId,
        ) =>
          navigateToEmailVerification(email, flowId),
      },
    );
    useBlocPresentationListener<SocialCubit, SocialEvent>(
      listener: (context, event) => switch (event) {
        SocialSuccessEvent() => context.go(HomeRoute().location),
        SocialVerifyEmailEvent(
          email: final email,
          flowId: final flowId,
        ) =>
          navigateToEmailVerification(email, flowId),
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: AppText(s.login_header),
        automaticallyImplyLeading: false,
      ),
      body: socialState.map(
        idle: (_) => const _LoginForm(),
        traitsStep: (socialState) => SocialTraitsForm(
          state: socialState,
        ),
      ),
    );
  }
}

class _LoginForm extends HookWidget {
  const _LoginForm();

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    final cubit = context.watch<LoginCubit>();
    final socialCubit = context.watch<SocialCubit>();

    final state = cubit.state;
    final socialState = socialCubit.state;

    final formKey = useMemoized(GlobalKey<FormState>.new);

    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();

    void login() {
      if (formKey.currentState?.validate() ?? false) {
        final email = emailController.text;
        final password = passwordController.text;
        cubit.login(email: email, password: password);
      }
    }

    final error = state.error;

    return WillPopScope(
      onWillPop: () async => false,
      child: AppLoadingOverlay(
        isLoading: state.inProgress || socialState.inProgress,
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
                  controller: emailController,
                  textInputAction: TextInputAction.next,
                  label: AppText(s.email_field),
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  validator: MultiValidator<String>(
                    [
                      (text) => validateEmptyField(context, text),
                      (text) => validateEmail(context, text),
                    ],
                  ),
                ),
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
                AppSecondaryButton(
                  label: s.register,
                  onPressed: () => RegisterRoute().push<RegisterRoute>(context),
                ),
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
                const Spacer(),
                AppPrimaryButton(
                  label: s.login_page_recovery_button,
                  onPressed: () => RecoveryRoute().push<RecoveryRoute>(context),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
