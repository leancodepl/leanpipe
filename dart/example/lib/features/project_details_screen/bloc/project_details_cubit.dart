import 'package:app/common/bloc/single_query_cubit.dart';
import 'package:app/data/contracts.dart';
import 'package:leancode_contracts/leancode_contracts.dart';

class ProjectDetailsCubit extends SingleQueryCubit<ProjectDetailsDTO?> {
  ProjectDetailsCubit({
    required Cqrs cqrs,
    required String projectId,
  })  : _cqrs = cqrs,
        _projectId = projectId,
        super(fetch: () => cqrs.get(ProjectDetails(id: projectId)));

  final Cqrs _cqrs;
  final String _projectId;

  Future<void> addAssignment({required String name}) async {
    await _cqrs.run(
      AddAssignmentsToProject(
        projectId: _projectId,
        assignments: [AssignmentWriteDTO(name: name)],
      ),
    );

    return fetch();
  }
}
