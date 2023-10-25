import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_text_styles.dart';
import 'package:app/design_system_old/widgets/app_text.dart';
import 'package:flutter/material.dart';

void showSnackBar({
  required GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey,
  required String text,
}) {
  final messengerState = scaffoldMessengerKey.currentState;
  if (messengerState == null) {
    return;
  }

  final colors = messengerState.context.colors;

  final snackBar = SnackBar(
    margin: const EdgeInsets.all(24),
    backgroundColor: colors.bgDefaultPrimary,
    content: AppText(text, style: AppTextStyle.button),
    behavior: SnackBarBehavior.floating,
  );

  messengerState.showSnackBar(snackBar);
}
