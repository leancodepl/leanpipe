import 'package:app/common/colors.dart';
import 'package:app/common/widgets/app_design_system.dart';
import 'package:app/common/widgets/app_divider.dart';
import 'package:app/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends Page<void> {
  const HomePage({super.key});

  @override
  Route<void> createRoute(BuildContext context) => HomeRoute(this);
}

class HomeRoute extends MaterialPageRoute<void> {
  HomeRoute([HomePage? page])
      : super(
          settings: page,
          builder: (context) => const _HomeScreen(),
        );
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return ListTile(
      tileColor: colors.foregroundAccentTertiary,
      title: AppText(
        label,
        style: AppTextStyle.body,
      ),
      onTap: onTap,
    );
  }
}

class _HomeScreen extends StatelessWidget {
  const _HomeScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          _Tile(
            label: 'Projects',
            onTap: () => context.push(ProjectsRoute().location),
          ),
          const AppDivider(),
          _Tile(
            label: 'Employees',
            onTap: () => context.push(EmployeesRoute().location),
          ),
        ],
      ),
    );
  }
}
