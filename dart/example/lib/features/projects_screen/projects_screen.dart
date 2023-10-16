import 'package:app/data/contracts.dart';
import 'package:app/design_system/styleguide/typography.dart';
import 'package:app/design_system/widgets/text.dart';
import 'package:app/features/projects_screen/bloc/projects_cubit.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:app/features/widgets/error_screen.dart';
import 'package:app/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

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
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ProjectsCubit, SingleQueryState<List<ProjectDTO>>>(
        builder: (context, projectsState) => switch (projectsState) {
          SingleQueryError() => ErrorScreen(
              retry: context.read<ProjectsCubit>().fetch,
            ),
          SingleQueryLoading() => const CircularProgressIndicator(),
          SingleQuerySuccess(:final data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => ListTile(
                onTap: () => context.push(
                  Uri(
                    path: ProjectDetailsRoute().location,
                    queryParameters: {'projectId': data[index].id},
                  ).toString(),
                ),
                tileColor: Colors.grey,
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
