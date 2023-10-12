import 'package:app/design_system_old/app_design_system.dart';
import 'package:flutter/material.dart';

extension ColorsContextExtension on BuildContext {
  AppColors get colors => AppColors.of(this);
}
