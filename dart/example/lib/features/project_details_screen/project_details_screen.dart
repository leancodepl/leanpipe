import 'package:app/data/contracts.dart';
import 'package:app/design_system/styleguide/typography.dart';
import 'package:app/design_system/widgets/text.dart';
import 'package:app/features/project_details_screen/bloc/project_details_cubit.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:app/features/widgets/error_screen.dart';
import 'package:app/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class ProjectDetailsPage extends Page<void> {
  const ProjectDetailsPage({required this.projectId});

  final String? projectId;

  @override
  Route<void> createRoute(BuildContext context) =>
      ProjectDetailsPageRoute(projectId, this);
}

class ProjectDetailsPageRoute extends MaterialPageRoute<void> {
  ProjectDetailsPageRoute(
    String? projectId, [
    ProjectDetailsPage? page,
  ]) : super(
          settings: page,
          builder: (context) => switch (projectId) {
            final String projectId? => BlocProvider(
                create: (context) => ProjectDetailsCubit(
                  cqrs: context.read(),
                  projectId: projectId,
                )..fetch(),
                child: const ProjectDetailsScreen(),
              ),
            _ => const AppText(
                'Unknown project id',
                style: AppTextStyles.bodyDefault,
              ),
          },
        );
}

class ProjectDetailsScreen extends StatelessWidget {
  const ProjectDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<ProjectDetailsCubit,
          SingleQueryState<ProjectDetailsDTO?>>(
        builder: (context, state) => switch (state) {
          SingleQueryError() => ErrorScreen(
              retry: context.read<ProjectDetailsCubit>().fetch,
            ),
          SingleQueryLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          SingleQuerySuccess(:final data) => Center(
              child: switch (data) {
                final ProjectDetailsDTO projectDetails? => ListView.builder(
                    itemCount: projectDetails.assignments.length,
                    itemBuilder: (context, index) => ListTile(
                      onTap: () => context.push(
                        AssignmentRoute().location,
                        extra: projectDetails.assignments[index],
                      ),
                      tileColor: Colors.grey,
                      title: AppText(
                        projectDetails.assignments[index].name,
                        style: AppTextStyles.bodyDefault,
                      ),
                    ),
                  ),
                _ => const CircularProgressIndicator(),
              },
            ),
        },
      ),
    );
  }
}
