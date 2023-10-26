import 'package:app/common/colors.dart';
import 'package:app/common/widgets/app_design_system.dart';
import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.label,
    this.error,
    this.hint,
    this.textAlign = TextAlign.start,
    this.errorTextAlign = TextAlign.start,
    required this.controller,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.autofillHints = const [],
    this.textInputAction,
    this.keyboardType,
    this.suffixIcon,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.fillColor,
    this.enableBorder = true,
    this.onChanged,
    this.onSubmitted,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.minLines,
    this.maxLines = 1,
    this.hintMaxLines,
    this.enabled,
    this.spacing = 4,
  });

  final Widget? label;
  final String? error;
  final String? hint;
  final TextAlign textAlign;
  final TextAlign errorTextAlign;
  final TextEditingController? controller;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final Iterable<String>? autofillHints;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;
  final BorderRadius borderRadius;
  final Color? fillColor;
  final bool enableBorder;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmitted;
  final CrossAxisAlignment crossAxisAlignment;
  final int? minLines;
  final int? maxLines;
  final int? hintMaxLines;
  final bool? enabled;
  final double spacing;

  static const verticalContentPadding = 2.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final enabledBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: enableBorder
          ? BorderSide(
              color: error == null
                  ? colors.backgroundInfoSecondary
                  : colors.backgroundDangerPrimary,
            )
          : BorderSide.none,
    );

    final focusedBorder = enabledBorder.copyWith(
      borderSide: enableBorder
          ? BorderSide(
              color: error == null
                  ? colors.foregroundSuccessSecondary
                  : colors.backgroundDangerSecondary,
            )
          : BorderSide.none,
    );

    final label = this.label;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (label != null) ...[
          // ignore: use_design_system_item_AppDefaultTextStyle
          DefaultTextStyle(
            style: AppTextStyle.caption,
            child: label,
          ),
          SizedBox(height: spacing),
        ],
        // ignore: use_design_system_item_AppTextField
        TextField(
          controller: controller,
          obscureText: obscureText,
          autocorrect: autocorrect,
          enableSuggestions: enableSuggestions,
          autofillHints: autofillHints,
          textInputAction: textInputAction,
          keyboardType: keyboardType,
          style: AppTextStyle.subtitle,
          onChanged: onChanged,
          onSubmitted: (_) => onSubmitted?.call(),
          textAlign: textAlign,
          minLines: minLines,
          maxLines: maxLines,
          enabled: enabled,
          decoration: InputDecoration(
            filled: true,
            fillColor: fillColor ?? colors.backgroundDefaultPrimary,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              // 12 is the base vertical padding, anything lower is ignored
              vertical: 12 + verticalContentPadding,
            ),
            enabledBorder: enabledBorder,
            focusedBorder: focusedBorder,
            disabledBorder: enabledBorder,
            hintMaxLines: hintMaxLines,
            hintStyle: AppTextStyle.caption.copyWith(
              color: colors.foregroundWarningSecondary,
            ),
            hintText: hint,
            suffixIcon: suffixIcon != null
                ? Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.only(right: 16),
                    child: suffixIcon,
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              maxWidth: 22 + 16,
              maxHeight: 22,
            ),
          ),
        ),
        if (error case final error? when error.isNotEmpty) ...[
          SizedBox(height: spacing),
          AppText(
            error,
            style: AppTextStyle.caption,
            color: colors.backgroundDangerSecondary,
            textAlign: errorTextAlign,
          ),
        ],
      ],
    );
  }
}
