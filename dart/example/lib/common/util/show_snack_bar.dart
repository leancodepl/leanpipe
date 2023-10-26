import 'package:app/common/colors.dart';
import 'package:app/common/widgets/app_text.dart';
import 'package:app/common/widgets/app_text_styles.dart';
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
    backgroundColor: colors.backgroundDefaultPrimary,
    content: AppText(text, style: AppTextStyle.button),
    behavior: SnackBarBehavior.floating,
  );

  messengerState.showSnackBar(snackBar);
}
