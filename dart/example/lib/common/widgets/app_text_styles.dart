import 'package:flutter/material.dart';

// ignore: use_design_system_item_AppTextStyle
class AppTextStyle extends TextStyle {
  const AppTextStyle._({
    required double super.fontSize,
    required FontWeight weight,
    double? lineHeight,
    super.letterSpacing,
  }) : super(
          fontFamily: _familyName,
          fontWeight: weight,
          height: lineHeight != null ? lineHeight / fontSize : null,
        );

  static const _familyName = 'Mulish';

  // TODO: Currently not used. Uncomment when needed.
  // static const _weightRegular = FontWeight.w400;
  static const _weightMedium = FontWeight.w500;
  static const _weightBold = FontWeight.w700;

  static const headlineM = AppTextStyle._(
    fontSize: 24,
    weight: _weightBold,
    lineHeight: 32,
    letterSpacing: -0.021,
  );

  static const subtitle = AppTextStyle._(
    fontSize: 16,
    weight: _weightBold,
    lineHeight: 24,
    letterSpacing: -0.011,
  );

  static const body = AppTextStyle._(
    fontSize: 16,
    weight: _weightMedium,
    lineHeight: 24,
    letterSpacing: -0.011,
  );

  static const button = AppTextStyle._(
    fontSize: 16,
    weight: _weightMedium,
    lineHeight: 24,
    letterSpacing: -0.011,
  );

  static const caption = AppTextStyle._(
    fontSize: 12,
    weight: _weightMedium,
    lineHeight: 16,
    letterSpacing: 0,
  );
}
