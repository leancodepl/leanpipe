import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:flutter/material.dart';

/// By default uses `AppTextStyle.body` and `AppColors.text`
class AppText extends StatelessWidget {
  const AppText(
    this.data, {
    super.key,
    this.style,
    this.textAlign,
    this.color,
    this.overflow,
    this.maxLines,
  });

  final String data;
  final AppTextStyle? style;
  final TextAlign? textAlign;
  final Color? color;
  final TextOverflow? overflow;
  final int? maxLines;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = color ?? context.colors.fgDefaultPrimary;
    final effectiveStyle = (style ?? AppTextStyle.body).copyWith(
      color: effectiveColor,
    );

    // ignore: use_design_system_item_AppText
    return Text(
      data,
      style: effectiveStyle,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines ?? DefaultTextStyle.of(context).maxLines,
    );
  }
}
