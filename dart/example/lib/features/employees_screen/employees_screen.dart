import 'package:app/common/bloc/single_query_cubit.dart';
import 'package:app/common/colors.dart';
import 'package:app/common/widgets/app_add_floating_button.dart';
import 'package:app/common/widgets/app_design_system.dart';
import 'package:app/common/widgets/app_divider.dart';
import 'package:app/data/contracts.dart';
import 'package:app/features/employees_screen/bloc/employees_cubit.dart';
import 'package:app/features/error_screen/error_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class EmployeesPage extends Page<void> {
  const EmployeesPage({super.key});

  @override
  Route<void> createRoute(BuildContext context) => EmployeesPageRoute(this);
}

class EmployeesPageRoute extends MaterialPageRoute<void> {
  EmployeesPageRoute([EmployeesPage? page])
      : super(
          settings: page,
          builder: (context) => const _EmployeesScreen(),
        );
}

class _EmployeesScreen extends HookWidget {
  const _EmployeesScreen();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    useEffect(
      () {
        context.read<EmployeesCubit>().fetch();

        return;
      },
      const [],
    );

    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: AppAddFloatingButton(
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
          SingleQuerySuccess(:final data) => ListView.separated(
              itemCount: data.length,
              separatorBuilder: (context, _) => const AppDivider(),
              itemBuilder: (context, index) => ListTile(
                tileColor: colors.foregroundAccentTertiary,
                title: AppText(
                  data[index].id,
                  style: AppTextStyle.body,
                ),
              ),
            ),
        },
      ),
    );
  }
}
