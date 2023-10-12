import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

part 'login_cubit.freezed.dart';

class LoginCubit extends Cubit<LoginState>
    with BlocPresentationMixin<LoginState, LoginEvent> {
  LoginCubit({
    required this.kratosClient,
    required this.authCubit,
  }) : super(const LoginState());

  final KratosClient kratosClient;
  final AuthCubit authCubit;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    var currentState = state;

    if (currentState.inProgress) {
      return;
    }

    emit(
      currentState = currentState.copyWith(
        inProgress: true,
        error: null,
      ),
    );

    final result = await kratosClient.loginWithPassword(email, password);

    switch (result) {
      case UnverifiedAccountError():
        emitPresentation(
          LoginVerifyEmailEvent(
            email: result.emailToVerify,
            flowId: result.flowId,
          ),
        );
      case LoginSuccess():
        authCubit.emit(LoggedIn());
        emitPresentation(const LoginSuccessEvent());
      case LoginFailure(error: final error):
        emit(
          currentState = currentState.copyWith(
            error: LoginKratosError(error),
            inProgress: false,
          ),
        );
      case ErrorGettingFlowId():
      case UnknownLoginError():
        emit(
          currentState = currentState.copyWith(
            error: const LoginUnknownError(),
            inProgress: false,
          ),
        );
    }
  }
}

@freezed
class LoginState with _$LoginState {
  const factory LoginState({
    AuthFlowInfo? flowInfo,
    LoginError? error,
    @Default(false) bool inProgress,
  }) = _LoginState;
}

sealed class LoginError {
  const LoginError();
}

class LoginUnknownError extends LoginError {
  const LoginUnknownError();
}

class LoginKratosError extends LoginError {
  const LoginKratosError(this.error);

  final KratosError error;
}

sealed class LoginEvent {
  const LoginEvent();
}

class LoginSuccessEvent extends LoginEvent {
  const LoginSuccessEvent();
}

class LoginVerifyEmailEvent extends LoginEvent {
  const LoginVerifyEmailEvent({
    required this.email,
    required this.flowId,
  });

  final String? email;
  final String? flowId;
}
