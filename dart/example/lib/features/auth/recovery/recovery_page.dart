import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:app/design_system_old/widgets/app_pin_code_input.dart';
import 'package:app/design_system_old/widgets/app_text_form_field.dart';
import 'package:app/features/auth/kratos/common/multi_validator.dart';
import 'package:app/features/auth/kratos/common/validators.dart';
import 'package:app/features/auth/recovery/recovery_cubit.dart';
import 'package:app/navigation/routes.dart';
import 'package:app/resources/strings.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class RecoveryPage extends Page<void> {
  @override
  Route<void> createRoute(BuildContext context) => RecoveryPageRoute(this);
}

class RecoveryPageRoute extends MaterialPageRoute<void> {
  RecoveryPageRoute([RecoveryPage? page])
      : super(
          settings: page,
          builder: (context) => const RecoveryScreen(),
        );
}

class RecoveryScreen extends HookWidget {
  const RecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);
    final colors = context.colors;

    final recoveryCubit = useBloc(
      () => RecoveryCubit(
        kratosClient: context.read<KratosClient>(),
      )..getRecoveryFlow(),
    );

    return BlocPresentationListener<RecoveryCubit, RecoveryCubitEvent>(
      bloc: recoveryCubit,
      listener: (context, event) {
        switch (event) {
          case SuccessEvent():
            final snackBar = SnackBar(
              backgroundColor: colors.bgSuccessPrimary,
              content: AppText(s.recovery_page_password_changed),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            context.go(AuthRoute<void>().location);

          case ErrorEvent():
            final snackBar = SnackBar(
              backgroundColor: colors.bgDangerPrimary,
              content: AppText(s.kratos_error_system_generic),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            context.go(AuthRoute<void>().location);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: AppText(
            s.recovery_page_title,
          ),
          backgroundColor: colors.bgAccentPrimary,
        ),
        body: BlocBuilder<RecoveryCubit, RecoveryState>(
          bloc: recoveryCubit,
          builder: (context, state) {
            return switch (state) {
              RecoveryInitial _ => const Center(
                  child: AppLoadingOverlay(
                    isLoading: true,
                  ),
                ),
              RecoveryLoadingState _ => const Center(
                  child: AppLoadingOverlay(
                    isLoading: true,
                  ),
                ),
              RecoveryEmailEntry _ => RecoveryEnterEmailWidget(
                  recoveryCubit: recoveryCubit,
                ),
              RecoveryPinEntry _ => _PinCodeWidget(
                  recoveryCubit: recoveryCubit,
                ),
              final RecoveryFlowPinResult state => _KratosNewPasswordView(
                  recoveryCubit: recoveryCubit,
                  state: state,
                ),
              final RecoveryFlowErrorState _ => const Center(
                  child: AppLoadingOverlay(
                    isLoading: true,
                  ),
                ),
              final RecoverySuccessState _ => const Center(
                  child: AppLoadingOverlay(
                    isLoading: true,
                  ),
                ),
            };
          },
        ),
      ),
    );
  }
}

class RecoveryEnterEmailWidget extends HookWidget {
  const RecoveryEnterEmailWidget({required this.recoveryCubit, super.key});
  final RecoveryCubit recoveryCubit;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    final emailTextController = useTextEditingController();
    final formKey = GlobalKey<FormState>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              s.email_field,
            ),
            const SizedBox(height: 8),
            AppTextFormField(
              controller: emailTextController,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              validator: MultiValidator<String>(
                [
                  (text) => validateEmptyField(context, text),
                  (text) => validateEmail(context, text),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: AppPrimaryButton(
                label: s.recovery_page_send,
                onPressed: () {
                  if (formKey.currentState?.validate() ?? false) {
                    recoveryCubit.sendEmail(emailTextController.text);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PinCodeWidget extends StatelessWidget {
  const _PinCodeWidget({required this.recoveryCubit});

  final RecoveryCubit recoveryCubit;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    final pinController = AppPinCodeInputController();
    return AppPinCodeInput(
      fieldsCount: 6,
      title: s.recovery_page_pin_title,
      onComplete: recoveryCubit.sendCode,
      controller: pinController,
    );
  }
}

class _KratosNewPasswordView extends HookWidget {
  const _KratosNewPasswordView({
    required this.recoveryCubit,
    required this.state,
  });

  final RecoveryCubit recoveryCubit;
  final RecoveryFlowPinResult state;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    final passwordController = useTextEditingController();
    final repeatPasswordController = useTextEditingController();
    final formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppText(
              s.password_field,
            ),
            const SizedBox(height: 8),
            AppTextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              autocorrect: false,
              obscureText: true,
              validator: MultiValidator<String>(
                [
                  (text) => validateEmptyField(context, text),
                  (text) => validatePasswordLength(context, text),
                ],
              ),
            ),
            const SizedBox(height: 16),
            AppText(
              s.password_field,
            ),
            const SizedBox(height: 8),
            AppTextFormField(
              controller: repeatPasswordController,
              obscureText: true,
              autocorrect: false,
              validator: MultiValidator<String>(
                [
                  (text) => validateEmptyField(context, text),
                  (text) => validatePasswordLength(context, text),
                  (text) => validatePasswordsAreEqual(
                        context,
                        text,
                        passwordController.text,
                      ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: AppPrimaryButton(
                label: s.recovery_page_send,
                onPressed: () {
                  if ((formKey.currentState?.validate() ?? false) &&
                      (passwordController.text ==
                          repeatPasswordController.text)) {
                    recoveryCubit.setNewPassword(
                      newPassword: passwordController.text,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
