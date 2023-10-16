import 'package:app/data/contracts.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:cqrs/cqrs.dart';

class ProjectsCubit extends SingleQueryCubit<List<ProjectDTO>> {
  ProjectsCubit({required Cqrs cqrs})
      : super(fetch: cqrs.get(AllProjects(sortByNameDescending: false)));
}
