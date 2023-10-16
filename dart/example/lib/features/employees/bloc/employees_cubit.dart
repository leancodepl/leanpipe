import 'package:app/data/contracts.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:leancode_contracts/leancode_contracts.dart';

class EmployeesCubit extends SingleQueryCubit<List<EmployeeDTO>> {
  EmployeesCubit({required Cqrs cqrs}) : super(fetch: cqrs.get(AllEmployees()));
}
