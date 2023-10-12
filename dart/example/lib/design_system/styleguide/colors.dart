// ignore: use_design_system_item_AppColors
import 'package:flutter/material.dart' show AppBarTheme, ColorScheme, ThemeData;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Applies [AppColors] to descendant widgets.
class AppColorTheme extends InheritedWidget {
  /// Applies the given AppColors [colors] to [child].
  const AppColorTheme({
    super.key,
    required this.colors,
    required super.child,
  });

  /// Specifies the colors for descendant widgets.
  final AppColors colors;

  /// The data from the closest [AppColorTheme] instance that encloses the given
  /// context.
  static AppColors of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppColorTheme>()!.colors;

  @override
  bool updateShouldNotify(AppColorTheme oldWidget) =>
      colors != oldWidget.colors;
}

/// An extension for the [AppColorTheme] to use with context.
extension AppColorsExtension on BuildContext {
  /// Get current [AppColors] with context.
  AppColors get colors => AppColorTheme.of(this);
}

final class AppColor extends Color {
  /// Construct a color from the lower 24 bits of an [int] and optional
  /// opacity of type [double].
  ///
  /// The bits are interpreted as follows:
  ///
  /// * Bits 16-23 are the red value.
  /// * Bits 8-15 are the green value.
  /// * Bits 0-7 are the blue value.
  ///
  /// In other words, if RR is the red value in hex, GG the green value in hex,
  /// and BB the blue value in hex, a color can be expressed as
  /// `AppColor(0xRRGGBB)`.
  ///
  /// Although we only use the lower 24 bits it might be still better to pass
  /// color value in format of 0xAARRGGBB for that extra color preview in your
  /// IDE. The AA part will be ignored and overridden by [opacity].
  AppColor._(int value, {double opacity = 1})
      : super(_fromValueOpacity(value, opacity));

  static int _fromValueOpacity(int value, double opacity) =>
      ((opacity * 0xFF).toInt() & 0xFF) << 24 | (value & 0xFFFFFF);
}

final class AppColors {
  const AppColors._({
    required this.brightness,
    required this.backgroundAccentPrimary,
    required this.backgroundAccentPrimaryPressed,
    required this.backgroundAccentSecondary,
    required this.backgroundAccentTertiary,
    required this.backgroundAccentTertiaryPressed,
    required this.backgroundActivePrimary,
    required this.backgroundActivePrimaryPressed,
    required this.backgroundActiveSecondary,
    required this.backgroundActiveTertiary,
    required this.backgroundActiveTertiaryPressed,
    required this.backgroundInfoPrimary,
    required this.backgroundInfoPrimaryPressed,
    required this.backgroundInfoSecondary,
    required this.backgroundInfoTertiary,
    required this.backgroundInfoTertiaryPressed,
    required this.backgroundDangerPrimary,
    required this.backgroundDangerPrimaryPressed,
    required this.backgroundDangerSecondary,
    required this.backgroundDangerTertiary,
    required this.backgroundDangerTertiaryPressed,
    required this.backgroundSuccessPrimary,
    required this.backgroundSuccessPrimaryPressed,
    required this.backgroundSuccessSecondary,
    required this.backgroundSuccessTertiary,
    required this.backgroundSuccessTertiaryPressed,
    required this.backgroundWarningPrimary,
    required this.backgroundWarningPrimaryPressed,
    required this.backgroundWarningSecondary,
    required this.backgroundWarningTertiary,
    required this.backgroundWarningTertiaryPressed,
    required this.backgroundDefaultPrimary,
    required this.backgroundDefaultPrimaryPressed,
    required this.backgroundDefaultSecondary,
    required this.backgroundDefaultTertiary,
    required this.backgroundDefaultScrim,
    required this.backgroundInversePrimary,
    required this.backgroundInversePrimaryPressed,
    required this.backgroundDisabledPrimary,
    required this.backgroundDisabledSecondary,
    required this.backgroundDisabledTertiary,
    required this.foregroundAccentPrimary,
    required this.foregroundAccentPrimaryPressed,
    required this.foregroundAccentSecondary,
    required this.foregroundAccentSecondaryPressed,
    required this.foregroundAccentTertiary,
    required this.foregroundActivePrimary,
    required this.foregroundActivePrimaryPressed,
    required this.foregroundActiveSecondary,
    required this.foregroundActiveSecondaryPressed,
    required this.foregroundActiveTertiary,
    required this.foregroundInfoPrimary,
    required this.foregroundInfoPrimaryPressed,
    required this.foregroundInfoSecondary,
    required this.foregroundInfoSecondaryPressed,
    required this.foregroundInfoTertiary,
    required this.foregroundDangerPrimary,
    required this.foregroundDangerPrimaryPressed,
    required this.foregroundDangerSecondary,
    required this.foregroundDangerSecondaryPressed,
    required this.foregroundDangerTertiary,
    required this.foregroundSuccessPrimary,
    required this.foregroundSuccessPrimaryPressed,
    required this.foregroundSuccessSecondary,
    required this.foregroundSuccessSecondaryPressed,
    required this.foregroundSuccessTertiary,
    required this.foregroundWarningPrimary,
    required this.foregroundWarningPrimaryPressed,
    required this.foregroundWarningSecondary,
    required this.foregroundWarningSecondaryPressed,
    required this.foregroundWarningTertiary,
    required this.foregroundDefaultPrimary,
    required this.foregroundDefaultPrimaryPressed,
    required this.foregroundDefaultSecondary,
    required this.foregroundDefaultSecondaryPressed,
    required this.foregroundDefaultTertiary,
    required this.foregroundInversePrimary,
    required this.foregroundInversePrimaryPressed,
    required this.foregroundDisabledPrimary,
    required this.foregroundDisabledSecondary,
    required this.foregroundDisabledTertiary,
  });

  /// Brightness of the theme.
  final Brightness brightness;

  // Background
  // Accent
  final AppColor backgroundAccentPrimary;
  final AppColor backgroundAccentPrimaryPressed;
  final AppColor backgroundAccentSecondary;
  final AppColor backgroundAccentTertiary;
  final AppColor backgroundAccentTertiaryPressed;
  // Active
  final AppColor backgroundActivePrimary;
  final AppColor backgroundActivePrimaryPressed;
  final AppColor backgroundActiveSecondary;
  final AppColor backgroundActiveTertiary;
  final AppColor backgroundActiveTertiaryPressed;
  // Info
  final AppColor backgroundInfoPrimary;
  final AppColor backgroundInfoPrimaryPressed;
  final AppColor backgroundInfoSecondary;
  final AppColor backgroundInfoTertiary;
  final AppColor backgroundInfoTertiaryPressed;
  // Danger
  final AppColor backgroundDangerPrimary;
  final AppColor backgroundDangerPrimaryPressed;
  final AppColor backgroundDangerSecondary;
  final AppColor backgroundDangerTertiary;
  final AppColor backgroundDangerTertiaryPressed;
  // Success
  final AppColor backgroundSuccessPrimary;
  final AppColor backgroundSuccessPrimaryPressed;
  final AppColor backgroundSuccessSecondary;
  final AppColor backgroundSuccessTertiary;
  final AppColor backgroundSuccessTertiaryPressed;
  // Warning
  final AppColor backgroundWarningPrimary;
  final AppColor backgroundWarningPrimaryPressed;
  final AppColor backgroundWarningSecondary;
  final AppColor backgroundWarningTertiary;
  final AppColor backgroundWarningTertiaryPressed;
  // Default
  final AppColor backgroundDefaultPrimary;
  final AppColor backgroundDefaultPrimaryPressed;
  final AppColor backgroundDefaultSecondary;
  final AppColor backgroundDefaultTertiary;
  final AppColor backgroundDefaultScrim;
  // Inverse
  final AppColor backgroundInversePrimary;
  final AppColor backgroundInversePrimaryPressed;
  // Disabled
  final AppColor backgroundDisabledPrimary;
  final AppColor backgroundDisabledSecondary;
  final AppColor backgroundDisabledTertiary;

  // Foreground
  // Accent
  final AppColor foregroundAccentPrimary;
  final AppColor foregroundAccentPrimaryPressed;
  final AppColor foregroundAccentSecondary;
  final AppColor foregroundAccentSecondaryPressed;
  final AppColor foregroundAccentTertiary;
  // Active
  final AppColor foregroundActivePrimary;
  final AppColor foregroundActivePrimaryPressed;
  final AppColor foregroundActiveSecondary;
  final AppColor foregroundActiveSecondaryPressed;
  final AppColor foregroundActiveTertiary;
  // Info
  final AppColor foregroundInfoPrimary;
  final AppColor foregroundInfoPrimaryPressed;
  final AppColor foregroundInfoSecondary;
  final AppColor foregroundInfoSecondaryPressed;
  final AppColor foregroundInfoTertiary;
  // Danger
  final AppColor foregroundDangerPrimary;
  final AppColor foregroundDangerPrimaryPressed;
  final AppColor foregroundDangerSecondary;
  final AppColor foregroundDangerSecondaryPressed;
  final AppColor foregroundDangerTertiary;
  // Success
  final AppColor foregroundSuccessPrimary;
  final AppColor foregroundSuccessPrimaryPressed;
  final AppColor foregroundSuccessSecondary;
  final AppColor foregroundSuccessSecondaryPressed;
  final AppColor foregroundSuccessTertiary;
  // Warning
  final AppColor foregroundWarningPrimary;
  final AppColor foregroundWarningPrimaryPressed;
  final AppColor foregroundWarningSecondary;
  final AppColor foregroundWarningSecondaryPressed;
  final AppColor foregroundWarningTertiary;
  // Default
  final AppColor foregroundDefaultPrimary;
  final AppColor foregroundDefaultPrimaryPressed;
  final AppColor foregroundDefaultSecondary;
  final AppColor foregroundDefaultSecondaryPressed;
  final AppColor foregroundDefaultTertiary;
  // Inverse
  final AppColor foregroundInversePrimary;
  final AppColor foregroundInversePrimaryPressed;
  // Disabled
  final AppColor foregroundDisabledPrimary;
  final AppColor foregroundDisabledSecondary;
  final AppColor foregroundDisabledTertiary;

  /// Static transparent color, does not change depending on the theme.
  AppColor get transparent => AppColor._(0x00000000);

  /// A [ThemeData] based on a Material [ThemeData].
  ThemeData get materialTheme {
    return ThemeData(
      useMaterial3: true,
      splashColor: transparent,
      scaffoldBackgroundColor: backgroundDefaultPrimary,
      // ignore: use_design_system_item_AppColors
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: backgroundAccentPrimary,
        onPrimary: foregroundAccentPrimary,
        secondary: backgroundAccentSecondary,
        onSecondary: foregroundAccentSecondary,
        error: backgroundDangerPrimary,
        onError: foregroundAccentPrimary,
        background: backgroundDefaultPrimary,
        onBackground: foregroundDefaultPrimary,
        surface: backgroundDefaultSecondary,
        onSurface: foregroundDefaultSecondary,
      ),
      appBarTheme: AppBarTheme(
        systemOverlayStyle: brightness == Brightness.dark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
    );
  }
}

abstract final class AppColorThemes {
  static final light = AppColors._(
    brightness: Brightness.light,
    // Background
    // Accent
    backgroundAccentPrimary: AppColor._(0xFF7E17E5),
    backgroundAccentPrimaryPressed: AppColor._(0xFF6212B2),
    backgroundAccentSecondary: AppColor._(0xFFBD7EFD),
    backgroundAccentTertiary: AppColor._(0xFFF2E8FD),
    backgroundAccentTertiaryPressed: AppColor._(0xFFE0C2FF),
    // Active
    backgroundActivePrimary: AppColor._(0xFF7E17E5),
    backgroundActivePrimaryPressed: AppColor._(0xFF6212B2),
    backgroundActiveSecondary: AppColor._(0xFFBD7EFD),
    backgroundActiveTertiary: AppColor._(0xFFF2E8FD),
    backgroundActiveTertiaryPressed: AppColor._(0xFFE0C2FF),
    // Info
    backgroundInfoPrimary: AppColor._(0xFF176DE5),
    backgroundInfoPrimaryPressed: AppColor._(0xFF1255B2),
    backgroundInfoSecondary: AppColor._(0xFF7EB3FD),
    backgroundInfoTertiary: AppColor._(0xFFE9F2FD),
    backgroundInfoTertiaryPressed: AppColor._(0xFFCEDBEB),
    // Danger
    backgroundDangerPrimary: AppColor._(0xFFE61E17),
    backgroundDangerPrimaryPressed: AppColor._(0xFFB21712),
    backgroundDangerSecondary: AppColor._(0xFFFD827E),
    backgroundDangerTertiary: AppColor._(0xFFFDE8E8),
    backgroundDangerTertiaryPressed: AppColor._(0xFFFFC4C2),
    // Success
    backgroundSuccessPrimary: AppColor._(0xFF0D874A),
    backgroundSuccessPrimaryPressed: AppColor._(0xFF08542E),
    backgroundSuccessSecondary: AppColor._(0xFF73E5AC),
    backgroundSuccessTertiary: AppColor._(0xFFE8FDF2),
    backgroundSuccessTertiaryPressed: AppColor._(0xFFC2FFDF),
    // Warning
    backgroundWarningPrimary: AppColor._(0xFFA36810),
    backgroundWarningPrimaryPressed: AppColor._(0xFF70480B),
    backgroundWarningSecondary: AppColor._(0xFFFCCA7E),
    backgroundWarningTertiary: AppColor._(0xFFFDF4E8),
    backgroundWarningTertiaryPressed: AppColor._(0xFFFFE5C2),
    // Default
    backgroundDefaultPrimary: AppColor._(0xFFFFFFFF),
    backgroundDefaultPrimaryPressed: AppColor._(0xFFEDEFF7),
    backgroundDefaultSecondary: AppColor._(0xFFF0F2FA),
    backgroundDefaultTertiary: AppColor._(0xFFCAD1DE),
    backgroundDefaultScrim: AppColor._(0xFF040D29, opacity: 0.2),
    // Inverse
    backgroundInversePrimary: AppColor._(0xFF040D29),
    backgroundInversePrimaryPressed: AppColor._(0xFF3D4766),
    // Disabled
    backgroundDisabledPrimary: AppColor._(0xFFE8EAED),
    backgroundDisabledSecondary: AppColor._(0xFFECEEF2),
    backgroundDisabledTertiary: AppColor._(0xFFF4F6FA),

    // Foreground
    // Accent
    foregroundAccentPrimary: AppColor._(0xFF7E17E5),
    foregroundAccentPrimaryPressed: AppColor._(0xFF6212B2),
    foregroundAccentSecondary: AppColor._(0xFFBD7EFD),
    foregroundAccentSecondaryPressed: AppColor._(0xFF9159C9),
    foregroundAccentTertiary: AppColor._(0xFFF2E8FD),
    // Active
    foregroundActivePrimary: AppColor._(0xFF7E17E5),
    foregroundActivePrimaryPressed: AppColor._(0xFF6212B2),
    foregroundActiveSecondary: AppColor._(0xFFBD7EFD),
    foregroundActiveSecondaryPressed: AppColor._(0xFF9159C9),
    foregroundActiveTertiary: AppColor._(0xFFF2E8FD),
    // Info
    foregroundInfoPrimary: AppColor._(0xFF176DE5),
    foregroundInfoPrimaryPressed: AppColor._(0xFF1255B2),
    foregroundInfoSecondary: AppColor._(0xFF7EB3FD),
    foregroundInfoSecondaryPressed: AppColor._(0xFF5988C9),
    foregroundInfoTertiary: AppColor._(0xFFE9F2FD),
    // Danger
    foregroundDangerPrimary: AppColor._(0xFFE61E17),
    foregroundDangerPrimaryPressed: AppColor._(0xFFB21712),
    foregroundDangerSecondary: AppColor._(0xFFFD827E),
    foregroundDangerSecondaryPressed: AppColor._(0xFFC95C59),
    foregroundDangerTertiary: AppColor._(0xFFFDE8E8),
    // Success
    foregroundSuccessPrimary: AppColor._(0xFF0D874A),
    foregroundSuccessPrimaryPressed: AppColor._(0xFF08542E),
    foregroundSuccessSecondary: AppColor._(0xFF73E5AC),
    foregroundSuccessSecondaryPressed: AppColor._(0xFF5AB286),
    foregroundSuccessTertiary: AppColor._(0xFFE8FDF2),
    // Warning
    foregroundWarningPrimary: AppColor._(0xFFA36810),
    foregroundWarningPrimaryPressed: AppColor._(0xFF70480B),
    foregroundWarningSecondary: AppColor._(0xFFFDCA7E),
    foregroundWarningSecondaryPressed: AppColor._(0xFFC99C59),
    foregroundWarningTertiary: AppColor._(0xFFFDF4E8),
    // Default
    foregroundDefaultPrimary: AppColor._(0xFF040D29),
    foregroundDefaultPrimaryPressed: AppColor._(0xFF3D4766),
    foregroundDefaultSecondary: AppColor._(0xFF72798F),
    foregroundDefaultSecondaryPressed: AppColor._(0xFF515666),
    foregroundDefaultTertiary: AppColor._(0xFFCED3E0),
    // Inverse
    foregroundInversePrimary: AppColor._(0xFFFCFCFD),
    foregroundInversePrimaryPressed: AppColor._(0xFFE6E6EB),
    // Disabled
    foregroundDisabledPrimary: AppColor._(0xFFBCC1CC),
    foregroundDisabledSecondary: AppColor._(0xFFD3D7E0),
    foregroundDisabledTertiary: AppColor._(0xFFE2E6F0),
  );
}
