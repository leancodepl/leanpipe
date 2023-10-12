import 'package:app/design_system_old/app_design_system.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() => _build(
        brightness: Brightness.light,
        colorScheme: AppLightColors(),
      );

  static ThemeData _build({
    required Brightness brightness,
    required AppColors colorScheme,
  }) {
    return ThemeData.from(
      // ignore: use_design_system_item_AppColors
      colorScheme: ColorScheme(
        primary: colorScheme.fgInfoPrimary,
        secondary: colorScheme.fgInfoSecondary,
        surface: colorScheme.bgDefaultSecondary,
        background: colorScheme.bgDefaultPrimary,
        error: colorScheme.fgDangerPrimary,
        onPrimary: colorScheme.fgDefaultPrimary,
        onSecondary: colorScheme.fgDefaultSecondary,
        onSurface: colorScheme.fgDefaultTertiary,
        onBackground: colorScheme.fgDefaultTertiary,
        onError: colorScheme.fgDangerPrimary,
        brightness: brightness,
      ),
    );
  }
}
