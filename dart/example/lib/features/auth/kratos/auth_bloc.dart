import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required this.storage,
    required this.kratosClient,
  }) : super(Unauthorized());
  final FlutterSecureCredentialsStorage storage;
  final KratosClient kratosClient;

  Future<void> init() async {
    final expirationDate = await storage.readExpirationDate();

    if (expirationDate?.isAfter(DateTime.now()) ?? false) {
      await kratosClient.refreshSessionToken();
    } else {
      await storage.clear();
    }

    final result = await storage.read();
    emit(result != null ? LoggedIn() : Unauthorized());
    return;
  }
}

sealed class AuthState {}

class LoggedIn extends AuthState {}

class Unauthorized extends AuthState {}
