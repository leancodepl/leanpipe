import 'package:app/design_system_old/app_design_system.dart';
import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.backgroundColor,
    required this.textColor,
    this.leadingIcon,
    this.trailingIcon,
    this.analyticsParams = const {},
  });

  final String label;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Widget? leadingIcon;
  final Widget? trailingIcon;
  final Map<String, Object> analyticsParams;

  @override
  Widget build(BuildContext context) {
    const borderRadius = BorderRadius.all(Radius.circular(8));
    const duration = Duration(milliseconds: 120);

    return AnimatedOpacity(
      duration: duration,
      opacity: onPressed != null ? 1 : 0.5,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: onPressed,
            customBorder: const RoundedRectangleBorder(
              borderRadius: borderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  if (leadingIcon != null)
                    Expanded(child: leadingIcon!)
                  else
                    const Spacer(),
                  AppText(
                    label,
                    style: AppTextStyle.button,
                    color: textColor,
                  ),
                  if (trailingIcon != null)
                    Expanded(child: trailingIcon!)
                  else
                    const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
