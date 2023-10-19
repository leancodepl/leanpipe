import 'dart:async';

import 'package:app/data/contracts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_contracts/leancode_contracts.dart';
import 'package:leancode_pipe/leancode_pipe.dart';
import 'package:logging/logging.dart';

class AssignmentCubit extends Cubit<List<String>> {
  AssignmentCubit({
    required Cqrs cqrs,
    required PipeClient pipeClient,
    required String projectId,
    required AssignmentDTO assignmentDTO,
  })  : _cqrs = cqrs,
        _pipeClient = pipeClient,
        _projectId = projectId,
        _assignmentDTO = assignmentDTO,
        super([]);

  static const _employeeId = 'employee_01HCWMVECWCH7SNWH7RV5AVEZN';

  final Cqrs _cqrs;
  final PipeClient _pipeClient;

  final String _projectId;
  final AssignmentDTO _assignmentDTO;

  final _logger = Logger('AssignmentCubit');

  PipeSubscription<EmployeeAssignmentsTopic>? _pipeSubscription;
  StreamSubscription<EmployeeAssignmentsTopicNotification>?
      _assignmentsSubscription;

  Future<void> subscribe() async {
    try {
      if (_pipeClient.connectionState != PipeConnectionState.connected) {
        await _pipeClient.connect();
      }

      // final pipeSubscription = await _pipeClient.subscribe(
      //   ProjectEmployeesAssignmentsTopic(projectId: _projectId),
      // );
      final pipeSubscription = await _pipeClient
          .subscribe(EmployeeAssignmentsTopic(employeeId: _employeeId));

      _assignmentsSubscription = pipeSubscription.listen((value) {
        emit(
          [
            ...state,
            value.toString(),
          ],
        );
      });
    } catch (err, st) {
      _logger.warning('Failed to subscribe for messages', err, st);
    }
  }

  Future<void> assignEmployee() {
    return _cqrs.run(
      AssignEmployeeToAssignment(
        assignmentId: _assignmentDTO.id,
        employeeId: _employeeId,
      ),
    );
  }

  Future<void> unassignEmployee() {
    return _cqrs.run(
      UnassignEmployeeFromAssignment(assignmentId: _assignmentDTO.id),
    );
  }

  @override
  Future<void> close() async {
    await _assignmentsSubscription?.cancel();
    await _pipeSubscription?.unsubscribe();

    return super.close();
  }
}
