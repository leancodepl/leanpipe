// ignore_for_file: use_design_system_item_AppColors
import 'package:app/design_system_old/colors/app_light_colors.dart';
import 'package:flutter/material.dart';

abstract class AppColors {
  static AppColors of(BuildContext context) => AppLightColors();

  // Foreground

  // Foreground: Accent
  Color get fgAccentPrimary;
  Color get fgAccentPrimaryHover;
  Color get fgAccentPrimaryPressed;
  Color get fgAccentSecondary;
  Color get fgAccentSecondaryHover;
  Color get fgAccentSecondaryPressed;
  Color get fgAccentTertiary;

  // Foreground: Active
  Color get fgActivePrimary;
  Color get fgActivePrimaryHover;
  Color get fgActivePrimaryPressed;
  Color get fgActiveSecondary;
  Color get fgActiveSecondaryHover;
  Color get fgActiveSecondaryPressed;
  Color get fgActiveTertiary;

  // Foreground: Info
  Color get fgInfoPrimary;
  Color get fgInfoPrimaryHover;
  Color get fgInfoPrimaryPressed;
  Color get fgInfoSecondary;
  Color get fgInfoSecondaryHover;
  Color get fgInfoSecondaryPressed;
  Color get fgInfoTertiary;

  // Foreground: Danger
  Color get fgDangerPrimary;
  Color get fgDangerPrimaryHover;
  Color get fgDangerPrimaryPressed;
  Color get fgDangerSecondary;
  Color get fgDangerSecondaryHover;
  Color get fgDangerSecondaryPressed;
  Color get fgDangerTertiary;

  // Foreground: Success
  Color get fgSuccessPrimary;
  Color get fgSuccessPrimaryHover;
  Color get fgSuccessPrimaryPressed;
  Color get fgSuccessSecondary;
  Color get fgSuccessSecondaryHover;
  Color get fgSuccessSecondaryPressed;
  Color get fgSuccessTertiary;

  // Foreground: Warning
  Color get fgWarningPrimary;
  Color get fgWarningPrimaryHover;
  Color get fgWarningPrimaryPressed;
  Color get fgWarningSecondary;
  Color get fgWarningSecondaryHover;
  Color get fgWarningSecondaryPressed;
  Color get fgWarningTertiary;

  // Foreground: Default
  Color get fgDefaultPrimary;
  Color get fgDefaultPrimaryHover;
  Color get fgDefaultPrimaryPressed;
  Color get fgDefaultSecondary;
  Color get fgDefaultSecondaryHover;
  Color get fgDefaultSecondaryPressed;
  Color get fgDefaultTertiary;

  // Foreground: Inverse
  Color get fgInversePrimary;
  Color get fgInversePrimaryHover;
  Color get fgInversePrimaryPressed;

  // Foreground: Disabled
  Color get fgDisabledPrimary;
  Color get fgDisabledSecondary;
  Color get fgDisabledTertiary;

  // Background

  // Background: Accent
  Color get bgAccentPrimary;
  Color get bgAccentPrimaryHover;
  Color get bgAccentPrimaryPressed;
  Color get bgAccentSecondary;
  Color get bgAccentTertiary;
  Color get bgAccentTertiaryHover;
  Color get bgAccentTertiaryPressed;

  // Background: Active
  Color get bgActivePrimary;
  Color get bgActivePrimaryHover;
  Color get bgActivePrimaryPressed;
  Color get bgActiveSecondary;
  Color get bgActiveTertiary;
  Color get bgActiveTertiaryHover;
  Color get bgActiveTertiaryPressed;

  // Background: Info
  Color get bgInfoPrimary;
  Color get bgInfoPrimaryHover;
  Color get bgInfoPrimaryPressed;
  Color get bgInfoSecondary;
  Color get bgInfoTertiary;
  Color get bgInfoTertiaryHover;
  Color get bgInfoTertiaryPressed;

  // Background: Danger
  Color get bgDangerPrimary;
  Color get bgDangerPrimaryHover;
  Color get bgDangerPrimaryPressed;
  Color get bgDangerSecondary;
  Color get bgDangerTertiary;
  Color get bgDangerTertiaryHover;
  Color get bgDangerTertiaryPressed;

  // Background: Success
  Color get bgSuccessPrimary;
  Color get bgSuccessPrimaryHover;
  Color get bgSuccessPrimaryPressed;
  Color get bgSuccessSecondary;
  Color get bgSuccessTertiary;
  Color get bgSuccessTertiaryHover;
  Color get bgSuccessTertiaryPressed;

  // Background: Warning
  Color get bgWarningPrimary;
  Color get bgWarningPrimaryHover;
  Color get bgWarningPrimaryPressed;
  Color get bgWarningSecondary;
  Color get bgWarningTertiary;
  Color get bgWarningTertiaryHover;
  Color get bgWarningTertiaryPressed;

  // Background: Default
  Color get bgDefaultPrimary;
  Color get bgDefaultPrimaryHover;
  Color get bgDefaultPrimaryPressed;
  Color get bgDefaultSecondary;
  Color get bgDefaultTertiary;
  Color get bgDefaultScrim;

  // Background: Inverse
  Color get bgInversePrimary;
  Color get bgInversePrimaryHover;
  Color get bgInversePrimaryPressed;

  // Background: Disabled
  Color get bgDisabledPrimary;
  Color get bgDisabledSecondary;
  Color get bgDisabledTertiary;

  Color get transparent => Colors.transparent;
}
