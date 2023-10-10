import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_contracts/leancode_contracts.dart';
import 'package:leancode_pipe_example/data/contracts.dart';

class ProjectsCubit extends Cubit<List<ProjectDTO>> {
  ProjectsCubit({required Cqrs cqrs})
      : _cqrs = cqrs,
        super([]);

  final Cqrs _cqrs;

  Future<void> fetchProjects() async {
    final projects = await _cqrs.get(AllProjects(sortByNameDescending: false));

    if (projects case QuerySuccess(:final data)) {
      emit(data);
    }
  }
}
