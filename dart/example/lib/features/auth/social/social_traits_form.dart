import 'package:app/common/util/let.dart';
import 'package:app/design_system_old/widgets/app_form_field.dart';
import 'package:app/design_system_old/widgets/app_loading.dart';
import 'package:app/design_system_old/widgets/app_text.dart';
import 'package:app/design_system_old/widgets/app_text_form_field.dart';
import 'package:app/design_system_old/widgets/buttons/app_primary_button.dart';
import 'package:app/design_system_old/widgets/buttons/app_secondary_button.dart';
import 'package:app/features/auth/kratos/common/kratos_errors.dart';
import 'package:app/features/auth/kratos/common/multi_validator.dart';
import 'package:app/features/auth/kratos/common/trait.dart';
import 'package:app/features/auth/kratos/common/validators.dart';
import 'package:app/features/auth/social/social_cubit.dart';
import 'package:app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class SocialTraitsForm extends HookWidget {
  const SocialTraitsForm({
    super.key,
    required this.state,
  });

  final SocialTraitsState state;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    final cubit = context.watch<SocialCubit>();

    final state = cubit.state;

    final formKey = useMemoized(GlobalKey<FormState>.new);

    final emailTextController = useTextEditingController();
    final firstNameTextController = useTextEditingController();
    final familyNameTextController = useTextEditingController();
    final checkBoxValue = useState(false);

    final generalError = state.generalError;

    return AppLoadingOverlay(
      isLoading: state.inProgress,
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
                          SocialUnknownError() => s.social_traits_unknown_error,
                          SocialKratosGeneralError(error: final error) =>
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
                        cubit.finishRegisterWithOidc(
                          email: emailTextController.text,
                          givenName: firstNameTextController.text,
                          familyName: familyNameTextController.text,
                          regulationsAccepted: checkBoxValue.value,
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 16),
                  AppSecondaryButton(
                    label: s.social_traits_cancel,
                    onPressed: cubit.cancel,
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
