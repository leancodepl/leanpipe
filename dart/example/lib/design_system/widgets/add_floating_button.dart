import 'package:app/design_system/styleguide/colors.dart';
import 'package:flutter/material.dart';

class AppAddFloatingButton extends StatelessWidget {
  const AppAddFloatingButton({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: colors.foregroundAccentSecondary,
      child: const Icon(Icons.add),
    );
  }
}
