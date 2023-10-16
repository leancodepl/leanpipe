import 'package:app/data/contracts.dart';
import 'package:app/design_system_old/widgets/app_text.dart';
import 'package:app/features/assignment_screen/assignment_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AssignmentPage extends Page<void> {
  const AssignmentPage({required this.assignmentDTO});

  final AssignmentDTO? assignmentDTO;

  @override
  Route<void> createRoute(BuildContext context) =>
      AssignmentPageRoute(assignmentDTO, this);
}

class AssignmentPageRoute extends MaterialPageRoute<void> {
  AssignmentPageRoute(AssignmentDTO? assignmentDTO, [AssignmentPage? page])
      : super(
          settings: page,
          builder: (context) => BlocProvider(
            create: (context) => AssignmentCubit(
              cqrs: context.read(),
              pipeClient: context.read(),
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
            AppText('Pipe logs:'),
            for (final log in logs) AppText(log),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: context.read<AssignmentCubit>().assignEmployee,
        label: AppText('Assign employee'),
      ),
    );
  }
}
