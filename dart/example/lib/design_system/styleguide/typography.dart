// ignore_for_file: use_design_system_item_AppTextStyle
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum AppTextTransform {
  none,
  uppercase;

  String transform(String text) => switch (this) {
        uppercase => text.toUpperCase(),
        _ => text,
      };
}

final class AppTextStyle extends TextStyle {
  const AppTextStyle._({
    required this.styleName,
    required String super.fontFamily,
    required double super.fontSize,
    required double height,
    required FontWeight super.fontWeight,
    required double super.letterSpacing,
    this.textTransform = AppTextTransform.none,
    FontStyle super.fontStyle = FontStyle.normal,
  }) : super(
          height: height / fontSize,
          fontFeatures: const [FontFeature.tabularFigures()],
          leadingDistribution: TextLeadingDistribution.even,
        );

  final String styleName;
  final AppTextTransform textTransform;

  @override
  String toStringShort() => 'AppTextStyle.$styleName';

  @override
  void debugFillProperties(
    DiagnosticPropertiesBuilder properties, {
    String prefix = '',
  }) {
    super.debugFillProperties(properties, prefix: prefix);
    properties.add(
      DiagnosticsProperty<AppTextTransform>('textTransform', textTransform),
    );
  }
}

abstract final class AppTextStyles {
  static const display = AppTextStyle._(
    styleName: 'display',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 40,
    height: 56,
    letterSpacing: -0.022,
  );

  static const headlineLarge = AppTextStyle._(
    styleName: 'headlineLarge',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 32,
    height: 40,
    letterSpacing: -0.021,
  );

  static const headlineMedium = AppTextStyle._(
    styleName: 'headlineMedium',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 24,
    height: 32,
    letterSpacing: -0.021,
  );

  static const headlineSmall = AppTextStyle._(
    styleName: 'headlineSmall',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w600,
    fontSize: 20,
    height: 24,
    letterSpacing: -0.021,
  );

  static const subtitle = AppTextStyle._(
    styleName: 'subtitle',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 24,
    letterSpacing: -0.011,
  );

  static const bodyDefault = AppTextStyle._(
    styleName: 'bodyDefault',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24,
    letterSpacing: -0.011,
  );

  static const bodyStrong = AppTextStyle._(
    styleName: 'bodyStrong',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 16,
    height: 24,
    letterSpacing: -0.011,
  );

  static const bodyItalic = AppTextStyle._(
    styleName: 'bodyItalic',
    fontFamily: 'Inter',
    fontStyle: FontStyle.italic,
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24,
    letterSpacing: -0.011,
  );

  static const button = AppTextStyle._(
    styleName: 'button',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    height: 24,
    letterSpacing: -0.011,
  );

  static const captionDefault = AppTextStyle._(
    styleName: 'captionDefault',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    height: 16,
    letterSpacing: 0,
  );

  static const captionStrong = AppTextStyle._(
    styleName: 'captionStrong',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w700,
    fontSize: 12,
    height: 16,
    letterSpacing: 0,
  );

  static const overline = AppTextStyle._(
    styleName: 'overline',
    fontFamily: 'Inter',
    fontWeight: FontWeight.w500,
    fontSize: 12,
    textTransform: AppTextTransform.uppercase,
    height: 16,
    letterSpacing: 0,
  );

  static const values = [
    display,
    headlineLarge,
    headlineMedium,
    headlineSmall,
    subtitle,
    bodyDefault,
    bodyStrong,
    bodyItalic,
    button,
    captionDefault,
    captionStrong,
    overline,
  ];
}
