import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:flutter/material.dart';

class AppTextFieldError extends StatelessWidget {
  const AppTextFieldError({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Row(
      children: [
        // TODO: Replace with icon from design system
        Icon(
          Icons.error,
          color: colors.fgDangerPrimary,
          size: 16,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: AppText(
            message,
            style: AppTextStyle.body,
            color: colors.fgDangerPrimary,
          ),
        ),
      ],
    );
  }
}
