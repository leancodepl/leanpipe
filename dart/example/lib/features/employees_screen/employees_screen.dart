import 'package:app/data/contracts.dart';
import 'package:app/design_system/styleguide/typography.dart';
import 'package:app/design_system/widgets/text.dart';
import 'package:app/features/employees_screen/bloc/employees_cubit.dart';
import 'package:app/features/single_query_cubit.dart';
import 'package:app/features/widgets/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EmployeesPage extends Page<void> {
  const EmployeesPage({super.key});

  @override
  Route<void> createRoute(BuildContext context) => EmployeesPageRoute(this);
}

class EmployeesPageRoute extends MaterialPageRoute<void> {
  EmployeesPageRoute([EmployeesPage? page])
      : super(
          settings: page,
          builder: (context) => BlocProvider(
            create: (context) => EmployeesCubit(cqrs: context.read())..fetch(),
            child: const _EmployeesScreen(),
          ),
        );
}

class _EmployeesScreen extends StatelessWidget {
  const _EmployeesScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: context.read<EmployeesCubit>().createEmployee,
      ),
      body: BlocBuilder<EmployeesCubit, SingleQueryState<List<EmployeeDTO>>>(
        builder: (context, state) => switch (state) {
          SingleQueryLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          SingleQueryError() => ErrorScreen(
              retry: context.read<EmployeesCubit>().fetch,
            ),
          SingleQuerySuccess(:final data) => ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) => ListTile(
                tileColor: Colors.grey,
                title: AppText(
                  data[index].id,
                  style: AppTextStyles.bodyDefault,
                ),
              ),
            ),
        },
      ),
    );
  }
}
