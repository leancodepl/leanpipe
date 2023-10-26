import 'package:app/common/config/app_global_keys.dart';
import 'package:app/data/contracts.dart';
import 'package:app/design_system/styleguide/colors.dart';
import 'package:app/design_system/styleguide/typography.dart';
import 'package:app/design_system/widgets/add_floating_button.dart';
import 'package:app/design_system/widgets/divider.dart';
import 'package:app/design_system/widgets/text.dart';
import 'package:app/features/employees_screen/bloc/employees_cubit.dart';
import 'package:app/features/project_details_screen/bloc/project_details_cubit.dart';
import 'package:app/features/show_snack_bar.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:app/features/widgets/error_screen.dart';
import 'package:app/navigation/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:word_generator/word_generator.dart';

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
    final colors = context.colors;

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: AppAddFloatingButton(
        onPressed: () => context
            .read<ProjectDetailsCubit>()
            .addAssignment(name: WordGenerator().randomName()),
      ),
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
                final ProjectDetailsDTO projectDetails? => ListView.separated(
                    itemCount: projectDetails.assignments.length,
                    separatorBuilder: (context, _) => const AppDivider(),
                    itemBuilder: (context, index) => ListTile(
                      onTap: () {
                        final employeesState =
                            context.read<EmployeesCubit>().state;

                        switch (employeesState) {
                          case SingleQuerySuccess(:final data)
                              when data.isNotEmpty:
                            context.push(
                              Uri(
                                path: AssignmentRoute().location,
                                queryParameters: {
                                  'projectId': projectDetails.id,
                                  'employeeId': data[0].id,
                                },
                              ).toString(),
                              extra: projectDetails.assignments[index],
                            );
                          default:
                            showSnackBar(
                              scaffoldMessengerKey: context
                                  .read<AppGlobalKeys>()
                                  .scaffoldMessengerKey,
                              text:
                                  'Employees list is either empty or has not been fetched',
                            );
                            return;
                        }
                      },
                      tileColor: colors.foregroundAccentTertiary,
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
