import 'dart:async';

import 'package:app/data/contracts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_contracts/leancode_contracts.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_client.dart';
import 'package:leancode_pipe/leancode_pipe/pipe_subscription.dart';

class AssignmentCubit extends Cubit<List<String>> {
  AssignmentCubit({
    required Cqrs cqrs,
    required PipeClient pipeClient,
    required AssignmentDTO? assignmentDTO,
  })  : _cqrs = cqrs,
        _pipeClient = pipeClient,
        _assignmentDTO = assignmentDTO,
        super([]);

  static const _employeeId = 'employee_01HCWMVECWCH7SNWH7RV5AVEZN';

  final Cqrs _cqrs;
  final PipeClient _pipeClient;

  final AssignmentDTO? _assignmentDTO;

  PipeSubscription<EmployeeAssignmentsTopicNotification>? _pipeSubscription;
  StreamSubscription<EmployeeAssignmentsTopicNotification>? _topicSubscription;

  Future<void> subscribe() async {
    final pipeSubscription = await _pipeClient.subscribe(
      EmployeeAssignmentsTopic(employeeId: _employeeId),
    );

    _topicSubscription = pipeSubscription.listen((value) {
      emit(
        [
          ...state,
          value.toString(),
        ],
      );
    });
  }

  Future<void> assignEmployee() {
    final assignment = _assignmentDTO;
    if (assignment == null) {
      throw StateError('AssignmentDTO is null');
    }

    return _cqrs.run(
      AssignEmployeeToAssignment(
        assignmentId: assignment.id,
        employeeId: _employeeId,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _topicSubscription?.cancel();
    await _pipeSubscription?.unsubscribe();

    return super.close();
  }
}
