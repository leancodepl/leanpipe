import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class DashboardCubit extends Cubit<void> {
  DashboardCubit({
    required this.kratosClient,
    required this.authCubit,
  }) : super(null);

  final KratosClient kratosClient;
  final AuthCubit authCubit;

  Future<void> logout() async {
    await kratosClient.logout();
    authCubit.emit(Unauthorized());
  }
}
