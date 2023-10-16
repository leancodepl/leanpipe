import 'package:app/design_system/styleguide/typography.dart';
import 'package:app/design_system/widgets/text.dart';
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

// TODO: Style
class _Tile extends StatelessWidget {
  const _Tile({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Colors.red,
      title: AppText(
        label,
        style: AppTextStyles.bodyDefault,
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
          _Tile(
            label: 'Employees',
            onTap: () => context.push(EmployeesRoute().location),
          ),
        ],
      ),
    );
  }
}
