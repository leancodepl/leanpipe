import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:app/design_system_old/widgets/app_text_form_field.dart';
import 'package:app/features/auth/kratos/common/multi_validator.dart';
import 'package:app/features/auth/kratos/common/validators.dart';
import 'package:app/features/auth/menu/menu_cubit.dart';
import 'package:app/features/auth/menu/profile/profile_cubit.dart';
import 'package:app/navigation/routes.dart';
import 'package:app/resources/strings.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class ProfilePage extends Page<void> {
  const ProfilePage();

  @override
  Route<void> createRoute(BuildContext context) => ProfilePageRoute(this);
}

class ProfilePageRoute extends MaterialPageRoute<void> {
  ProfilePageRoute([
    ProfilePage? page,
  ]) : super(
          settings: page,
          builder: (context) => BlocProvider(
            create: (context) => ProfileCubit(
              kratosClient: context.read<KratosClient>(),
              menuCubit: context.read<MenuCubit>(),
            ),
            child: const ProfilePageScreen(),
          ),
        );
}

class ProfilePageScreen extends StatelessWidget {
  const ProfilePageScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(
        title: AppText(
          s.profile_my_profile,
        ),
        backgroundColor: colors.bgAccentPrimary,
      ),
      body: const ProfileForm(),
    );
  }
}

class ProfileForm extends HookWidget {
  const ProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);
    final colors = context.colors;

    final menuCubit = context.read<MenuCubit>();
    final editEnabled = useState<bool>(false);
    final cubit = context.watch<ProfileCubit>();

    final emailTextController = useTextEditingController(text: menuCubit.email);
    final firstNameTextController =
        useTextEditingController(text: menuCubit.givenName);
    final familyNameTextController =
        useTextEditingController(text: menuCubit.familyName);

    final formKey = useMemoized(GlobalKey<FormState>.new);

    void updateProfile() {
      if (formKey.currentState?.validate() ?? false) {
        cubit.updateTraits(
          email: emailTextController.text,
          name: firstNameTextController.text,
          surname: familyNameTextController.text,
        );
      }
    }

    useBlocPresentationListener<ProfileCubit, ProfileEvent>(
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
          case ProfileUpdateRequiresReauthentication():
            final result =
                await context.push<bool>(ReauthorizationRoute().location);
            if (result ?? false) {
              updateProfile();
            }
        }
      },
    );

    return AppLoadingOverlay(
      isLoading: cubit.state is ProfileLoading,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  AppFormField(
                    header: s.email_field,
                    widgetBelow: AppTextFormField(
                      enabled: editEnabled.value,
                      controller: emailTextController,
                      textInputAction: TextInputAction.next,
                      autocorrect: false,
                      keyboardType: TextInputType.emailAddress,
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
                      enabled: editEnabled.value,
                      controller: firstNameTextController,
                      textInputAction: TextInputAction.next,
                      validator: MultiValidator<String>(
                        [
                          (text) => validateEmptyField(context, text),
                        ],
                      ),
                    ),
                  ),
                  AppFormField(
                    header: s.register_family_name_field,
                    widgetBelow: AppTextFormField(
                      enabled: editEnabled.value,
                      controller: familyNameTextController,
                      validator: MultiValidator<String>(
                        [
                          (text) => validateEmptyField(context, text),
                        ],
                      ),
                    ),
                  ),
                  CheckboxListTile(
                    value: true,
                    enabled: false,
                    onChanged: (_) {},
                    title: AppText(s.terms_conditions_checkbox),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.zero,
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  if (!editEnabled.value)
                    AppSecondaryButton(
                      label: s.profile_edit_form,
                      onPressed: () {
                        editEnabled.value = true;
                      },
                    )
                  else
                    AppPrimaryButton(
                      label: s.profile_save_changes,
                      onPressed: updateProfile,
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
