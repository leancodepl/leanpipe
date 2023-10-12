import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leadingIcon,
    this.trailingIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final Widget? leadingIcon;
  final Widget? trailingIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return AppButton(
      key: key,
      label: label,
      onPressed: onPressed,
      leadingIcon: leadingIcon,
      trailingIcon: trailingIcon,
      backgroundColor: colors.bgInfoPrimary,
      textColor: colors.fgInversePrimary,
    );
  }
}
