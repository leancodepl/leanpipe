import 'package:app/data/contracts.dart';
import 'package:app/design_system_old/widgets/app_text.dart';
import 'package:app/features/assignment_screen/assignment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentPage extends Page<void> {
  const AssignmentPage({
    required this.projectId,
    required this.assignmentDTO,
  });

  final String projectId;
  final AssignmentDTO assignmentDTO;

  @override
  Route<void> createRoute(BuildContext context) => AssignmentPageRoute(
        projectId,
        assignmentDTO,
        this,
      );
}

class AssignmentPageRoute extends MaterialPageRoute<void> {
  AssignmentPageRoute(
    String projectId,
    AssignmentDTO assignmentDTO, [
    AssignmentPage? page,
  ]) : super(
          settings: page,
          builder: (context) => BlocProvider(
            create: (context) => AssignmentCubit(
              cqrs: context.read(),
              pipeClient: context.read(),
              projectId: projectId,
              assignmentDTO: assignmentDTO,
            )..subscribe(),
            child: AssignmentScreen(assignmentDTO: assignmentDTO),
          ),
        );
}

class AssignmentScreen extends StatelessWidget {
  const AssignmentScreen({
    super.key,
    required this.assignmentDTO,
  });

  final AssignmentDTO? assignmentDTO;

  @override
  Widget build(BuildContext context) {
    final assignment = assignmentDTO;

    if (assignment == null) {
      return const SizedBox();
    }

    return Scaffold(
      appBar: AppBar(title: AppText('Assignment "${assignment.name}"')),
      body: BlocBuilder<AssignmentCubit, List<String>>(
        builder: (context, logs) => ListView(
          children: [
            const AppText('Pipe logs:'),
            for (final log in logs) AppText(log),
          ],
        ),
      ),
      floatingActionButton: Row(
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: context.read<AssignmentCubit>().assignEmployee,
            label: const AppText('Assign employee'),
          ),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: context.read<AssignmentCubit>().unassignEmployee,
            label: const AppText('unassign employee'),
          ),
        ],
      ),
    );
  }
}
