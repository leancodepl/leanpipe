import 'package:app/common/bloc/single_query_cubit.dart';
import 'package:app/data/contracts.dart';
import 'package:cqrs/cqrs.dart';

sealed class ProjectsCubitEvent {
  const ProjectsCubitEvent();
}

class FailedToCreateProject implements ProjectsCubitEvent {
  const FailedToCreateProject();
}

class ProjectsCubit extends SingleQueryCubit<List<ProjectDTO>> {
  ProjectsCubit({required Cqrs cqrs})
      : _cqrs = cqrs,
        super(fetch: () => cqrs.get(AllProjects(sortByNameDescending: false)));

  final Cqrs _cqrs;

  Future<void> createProject({required String name}) async {
    final response = await _cqrs.run(CreateProject(name: name));

    if (response case CommandSuccess()) {
      return fetch();
    }
  }
}
