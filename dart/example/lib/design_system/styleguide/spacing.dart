import 'package:flutter/widgets.dart';

abstract final class AppSpacings {
  static const zero = AppSpacing._(0);
  static const s = AppSpacing._(4);
  static const m = AppSpacing._(8);
  static const x = AppSpacing._(16);
  static const xl = AppSpacing._(32);
}

final class AppSpacing {
  const AppSpacing._(this.value);

  final double value;

  EdgeInsetsDirectional get all => EdgeInsetsDirectional.all(value);

  EdgeInsetsDirectional get horizontal =>
      EdgeInsetsDirectional.symmetric(horizontal: value);
  EdgeInsetsDirectional get vertical =>
      EdgeInsetsDirectional.symmetric(vertical: value);

  EdgeInsetsDirectional get start => EdgeInsetsDirectional.only(start: value);
  EdgeInsetsDirectional get end => EdgeInsetsDirectional.only(end: value);
  EdgeInsetsDirectional get top => EdgeInsetsDirectional.only(top: value);
  EdgeInsetsDirectional get bottom => EdgeInsetsDirectional.only(bottom: value);

  SizedBox get horizontalSpace => SizedBox(width: value);
  SizedBox get verticalSpace => SizedBox(height: value);
}
