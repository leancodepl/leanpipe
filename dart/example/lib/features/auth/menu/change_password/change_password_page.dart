import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:app/design_system_old/widgets/app_text_form_field.dart';
import 'package:app/features/auth/kratos/common/multi_validator.dart';
import 'package:app/features/auth/kratos/common/validators.dart';
import 'package:app/features/auth/menu/change_password/change_password_cubit.dart';
import 'package:app/features/auth/menu/menu_cubit.dart';
import 'package:app/navigation/routes.dart';
import 'package:app/resources/strings.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class ChangePasswordPage extends Page<void> {
  const ChangePasswordPage();
  @override
  Route<void> createRoute(BuildContext context) =>
      ChangePasswordPageRoute(this);
}

class ChangePasswordPageRoute extends MaterialPageRoute<void> {
  ChangePasswordPageRoute([
    ChangePasswordPage? page,
  ]) : super(
          settings: page,
          builder: (context) => BlocProvider(
            create: (context) => ChangePasswordCubit(
              kratosClient: context.read<KratosClient>(),
              menuCubit: context.read<MenuCubit>(),
            ),
            child: const _ChangePasswordPageScreen(),
          ),
        );
}

class _ChangePasswordPageScreen extends StatelessWidget {
  const _ChangePasswordPageScreen();

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          s.change_password_title,
        ),
        backgroundColor: colors.bgAccentPrimary,
      ),
      body: const _ChangePasswordForm(),
    );
  }
}

class _ChangePasswordForm extends HookWidget {
  const _ChangePasswordForm();

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);
    final colors = context.colors;

    final passwordController = useTextEditingController();
    final repeatPasswordController = useTextEditingController();
    final formKey = useMemoized(GlobalKey<FormState>.new);
    final cubit = context.watch<ChangePasswordCubit>();

    void changePassword() {
      if (formKey.currentState?.validate() ?? false) {
        cubit.changePassword(
          password: passwordController.text,
        );
      }
    }

    useBlocPresentationListener<ChangePasswordCubit, ChangePasswordEvent>(
      bloc: cubit,
      listener: (context, event) async {
        switch (event) {
          case SuccessEvent():
            final snackBar = SnackBar(
              backgroundColor: colors.bgSuccessPrimary,
              content: AppText(s.recovery_page_password_changed),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            context.pop();
          case ErrorEvent():
            final snackBar = SnackBar(
              backgroundColor: colors.bgDangerPrimary,
              content: AppText(s.kratos_error_system_generic),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
            context.pop();
          case AuthorizationNeeded():
            final result =
                await context.push<bool>(ReauthorizationRoute().location);
            if (result ?? false) {
              changePassword();
            }
        }
      },
    );

    return AppLoadingOverlay(
      isLoading: cubit.state is ChangePasswordLoading,
      child: Padding(
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
                s.change_password_confirm_password,
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
                  onPressed: changePassword,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
