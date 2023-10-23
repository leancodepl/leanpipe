import 'package:app/data/contracts.dart';
import 'package:app/design_system/styleguide/colors.dart';
import 'package:app/design_system/styleguide/typography.dart';
import 'package:app/design_system/widgets/add_floating_button.dart';
import 'package:app/design_system/widgets/divider.dart';
import 'package:app/design_system/widgets/text.dart';
import 'package:app/features/projects_screen/bloc/projects_cubit.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:app/features/widgets/error_screen.dart';
import 'package:app/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_generator/word_generator.dart';

class ProjectsPage extends Page<void> {
  const ProjectsPage();

  @override
  Route<void> createRoute(BuildContext context) => ProjectsPageRoute(this);
}

class ProjectsPageRoute extends MaterialPageRoute<void> {
  ProjectsPageRoute([ProjectsPage? page])
      : super(
          settings: page,
          builder: (context) => BlocProvider(
            create: (context) => ProjectsCubit(cqrs: context.read())..fetch(),
            child: const ProjectsScreen(),
          ),
        );
}

class ProjectsScreen extends StatelessWidget {
  const ProjectsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      floatingActionButton: AppAddFloatingButton(
        onPressed: () => context
            .read<ProjectsCubit>()
            .createProject(name: WordGenerator().randomName()),
      ),
      appBar: AppBar(),
      body: BlocBuilder<ProjectsCubit, SingleQueryState<List<ProjectDTO>>>(
        builder: (context, projectsState) => switch (projectsState) {
          SingleQueryError() => ErrorScreen(
              retry: context.read<ProjectsCubit>().fetch,
            ),
          SingleQueryLoading() => const CircularProgressIndicator(),
          SingleQuerySuccess(:final data) => ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, _) => const AppDivider(),
              itemBuilder: (context, index) => ListTile(
                onTap: () => context.push(
                  Uri(
                    path: ProjectDetailsRoute().location,
                    queryParameters: {'projectId': data[index].id},
                  ).toString(),
                ),
                tileColor: colors.foregroundAccentTertiary,
                title: AppText(
                  data[index].name,
                  style: AppTextStyles.bodyDefault,
                ),
              ),
            ),
        },
      ),
    );
  }
}
