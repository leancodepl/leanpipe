import 'package:app/common/widgets/buttons/app_primary_button.dart';
import 'package:app/resources/strings.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.retry,
  });

  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    return Center(
      child: AppPrimaryButton(
        label: s.error_handling_unknown,
        onPressed: retry,
      ),
    );
  }
}
