import 'package:app/common/widgets/app_text.dart';
import 'package:app/common/widgets/app_text_styles.dart';
import 'package:app/data/contracts.dart';
import 'package:app/features/assignment_screen/assignment_cubit.dart';
import 'package:app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentPage extends Page<void> {
  const AssignmentPage({
    required this.projectId,
    required this.assignmentDTO,
    required this.employeeId,
  });

  final String projectId;
  final AssignmentDTO assignmentDTO;
  final String employeeId;

  @override
  Route<void> createRoute(BuildContext context) => AssignmentPageRoute(
        projectId,
        assignmentDTO,
        employeeId,
        this,
      );
}

class AssignmentPageRoute extends MaterialPageRoute<void> {
  AssignmentPageRoute(
    String projectId,
    AssignmentDTO assignmentDTO,
    String employeeId, [
    AssignmentPage? page,
  ]) : super(
          settings: page,
          builder: (context) => BlocProvider(
            create: (context) => AssignmentCubit(
              cqrs: context.read(),
              pipeClient: context.read(),
              projectId: projectId,
              assignmentDTO: assignmentDTO,
              employeeId: employeeId,
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

    final s = l10n(context);

    return Scaffold(
      appBar: AppBar(
        title: AppText(s.assignment_screen_title(assignment.name)),
      ),
      bottomSheet: Padding(
        padding: MediaQuery.paddingOf(context),
        child: Row(
          children: [
            const SizedBox(width: 32),
            Expanded(
              child: ElevatedButton(
                onPressed: context.read<AssignmentCubit>().assignEmployee,
                child: AppText(s.assignment_screen_assign),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: context.read<AssignmentCubit>().unassignEmployee,
                child: AppText(s.assignment_screen_unassign),
              ),
            ),
            const SizedBox(width: 32),
          ],
        ),
      ),
      body: BlocBuilder<AssignmentCubit, List<String>>(
        builder: (context, logs) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 32),
            AppText(
              s.assignment_screen_pipe_logs,
              style: AppTextStyle.headlineM,
            ),
            const SizedBox(height: 16),
            for (final log in logs) AppText(log),
            if (logs.isEmpty)
              AppText(s.assignment_screen_pipe_logs_placeholder),
          ],
        ),
      ),
    );
  }
}
