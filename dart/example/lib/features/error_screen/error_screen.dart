import 'package:app/common/widgets/app_design_system.dart';
import 'package:app/common/widgets/buttons/app_primary_button.dart';
import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.retry,
  });

  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const AppText(
          'An error occured',
          style: AppTextStyle.body,
        ),
        const SizedBox(height: 16),
        AppPrimaryButton(label: 'Try again', onPressed: retry),
      ],
    );
  }
}