import 'package:app/data/contracts.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:leancode_contracts/leancode_contracts.dart';

class ProjectDetailsCubit extends SingleQueryCubit<ProjectDetailsDTO?> {
  ProjectDetailsCubit({required Cqrs cqrs, required String projectId})
      : super(fetch: () => cqrs.get(ProjectDetails(id: projectId)));
}
