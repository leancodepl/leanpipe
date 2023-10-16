import 'dart:math';

import 'package:app/data/contracts.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:leancode_contracts/leancode_contracts.dart';

String _generateRandomString(int len) {
  final r = Random();
  return String.fromCharCodes(
    List.generate(len, (index) => r.nextInt(33) + 89),
  );
}

class EmployeesCubit extends SingleQueryCubit<List<EmployeeDTO>> {
  EmployeesCubit({required Cqrs cqrs})
      : _cqrs = cqrs,
        super(fetch: () => cqrs.get(AllEmployees()));

  final Cqrs _cqrs;

  Future<void> createEmployee() async {
    await _cqrs.run(
      CreateEmployee(
        name: _generateRandomString(10),
        email: '${_generateRandomString(10)}@gmail.com',
      ),
    );

    return fetch();
  }
}
