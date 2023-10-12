import 'package:app/common/util/let.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:app/design_system_old/widgets/app_text_form_field.dart';
import 'package:app/features/auth/kratos/common/kratos_errors.dart';
import 'package:app/features/auth/kratos/common/multi_validator.dart';
import 'package:app/features/auth/kratos/common/trait.dart';
import 'package:app/features/auth/kratos/common/validators.dart';
import 'package:app/features/auth/register/register_cubit.dart';
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

class RegisterPage extends Page<void> {
  @override
  Route<void> createRoute(BuildContext context) => MaterialPageRoute<void>(
        builder: (context) => MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => RegisterCubit(
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
          child: const _RegisterScreen(),
        ),
        settings: this,
      );
}

class _RegisterScreen extends HookWidget {
  const _RegisterScreen();

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

    useBlocPresentationListener<RegisterCubit, RegisterEvent>(
      listener: (context, event) => switch (event) {
        RegisterSuccessEvent() => context.go(HomeRoute().location),
        RegisterVerifyEmailEvent(
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
      appBar: AppBar(title: AppText(s.register_header)),
      body: socialState.map(
        idle: (_) => const _RegisterForm(),
        traitsStep: (socialState) => SocialTraitsForm(state: socialState),
      ),
    );
  }
}

class _RegisterForm extends HookWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    final cubit = context.watch<RegisterCubit>();
    final socialCubit = context.watch<SocialCubit>();

    final state = cubit.state;
    final socialState = socialCubit.state;

    final formKey = useMemoized(GlobalKey<FormState>.new);

    final emailTextController = useTextEditingController();
    final passwordTextController = useTextEditingController();
    final firstNameTextController = useTextEditingController();
    final familyNameTextController = useTextEditingController();
    final checkBoxValue = useState(false);

    final generalError = state.generalError;

    return AppLoadingOverlay(
      isLoading: state.inProgress || socialState.inProgress,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  AppPrimaryButton(
                    label: s.register_with_apple_button,
                    onPressed: () =>
                        socialCubit.registerWithOidc(OidcProvider.apple),
                  ),
                  const SizedBox(height: 16),
                  AppPrimaryButton(
                    label: s.register_with_google_button,
                    onPressed: () =>
                        socialCubit.registerWithOidc(OidcProvider.google),
                  ),
                  const SizedBox(height: 16),
                  AppPrimaryButton(
                    label: s.register_with_facebook_button,
                    onPressed: () =>
                        socialCubit.registerWithOidc(OidcProvider.facebook),
                  ),
                  const SizedBox(height: 16),
                  AppFormField(
                    header: s.email_field,
                    widgetBelow: AppTextFormField(
                      controller: emailTextController,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
                      label: state.fieldErrors[Trait.email.key]
                          ?.let((error) => AppText(error.localized(context))),
                      validator: MultiValidator<String>(
                        [
                          (text) => validateEmptyField(context, text),
                          (text) => validateEmail(context, text),
                        ],
                      ),
                    ),
                  ),
                  AppFormField(
                    header: s.password_field,
                    widgetBelow: AppTextFormField(
                      controller: passwordTextController,
                      textInputAction: TextInputAction.next,
                      obscureText: true,
                      label: state.fieldErrors['password']
                          ?.let((error) => AppText(error.localized(context))),
                      validator: MultiValidator<String>(
                        [
                          (text) => validateEmptyField(context, text),
                          (text) => validatePasswordLength(context, text),
                        ],
                      ),
                    ),
                  ),
                  AppFormField(
                    header: s.register_first_name_field,
                    widgetBelow: AppTextFormField(
                      controller: firstNameTextController,
                      textInputAction: TextInputAction.next,
                      label: state.fieldErrors[Trait.givenName.key]
                          ?.let((error) => AppText(error.localized(context))),
                      validator: (text) => validateEmptyField(context, text),
                    ),
                  ),
                  AppFormField(
                    header: s.register_family_name_field,
                    widgetBelow: AppTextFormField(
                      controller: familyNameTextController,
                      label: state.fieldErrors[Trait.familyName.key]
                          ?.let((error) => AppText(error.localized(context))),
                      validator: (text) => validateEmptyField(context, text),
                    ),
                  ),
                  CheckboxListTile(
                    value: checkBoxValue.value,
                    onChanged: (value) {
                      if (value != null) {
                        checkBoxValue.value = value;
                      }
                    },
                    title: AppText(s.terms_conditions_checkbox),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(height: 32),
                  if (generalError != null) ...[
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: AppText(
                        switch (generalError) {
                          RegisterUnknownError() => s.register_unknown_error,
                          RegisterKratosGeneralError(error: final error) =>
                            error.localized(context),
                        },
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                  AppPrimaryButton(
                    label: s.register,
                    onPressed: () {
                      if (formKey.currentState?.validate() ?? false) {
                        cubit.registerWithPassword(
                          email: emailTextController.text,
                          password: passwordTextController.text,
                          givenName: firstNameTextController.text,
                          familyName: familyNameTextController.text,
                          regulationsAccepted: checkBoxValue.value,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
