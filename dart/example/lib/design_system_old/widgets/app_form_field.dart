import 'package:app/design_system_old/widgets/app_text.dart';
import 'package:flutter/material.dart';

class AppFormField extends StatelessWidget {
  const AppFormField({
    super.key,
    required this.header,
    required this.widgetBelow,
  });
  final String header;
  final Widget widgetBelow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          header,
        ),
        widgetBelow,
        const SizedBox(height: 16),
      ],
    );
  }
}
