import 'package:app/data/contracts.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:cqrs/cqrs.dart';

sealed class ProjectsCubitEvent {
  const ProjectsCubitEvent();
}

class FailedToCreateProject implements ProjectsCubitEvent {
  const FailedToCreateProject();
}

class ProjectsCubit extends SingleQueryCubit<List<ProjectDTO>>
    with
        BlocPresentationMixin<SingleQueryState<List<ProjectDTO>>,
            ProjectsCubitEvent> {
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
