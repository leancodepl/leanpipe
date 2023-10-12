import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

part 'reauthorize_cubit.freezed.dart';

class ReauthorizeCubit extends Cubit<ReauthorizeState>
    with BlocPresentationMixin<ReauthorizeState, ReauthorizeCubitEvent> {
  ReauthorizeCubit({required this.kratosClient})
      : super(const ReauthorizeState());

  final KratosClient kratosClient;

  Future<void> reauthorizeWithPassword({
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

    final result = await kratosClient.loginWithPassword(
      email,
      password,
      refresh: true,
    );

    switch (result) {
      case LoginSuccess():
        emitPresentation(ReauthorizeSuccess());
      case LoginFailure(error: final error):
        emit(
          currentState = currentState.copyWith(
            error: LoginKratosError(error),
            inProgress: false,
          ),
        );
      case ErrorGettingFlowId():
      case UnverifiedAccountError():
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
class ReauthorizeState with _$ReauthorizeState {
  const factory ReauthorizeState({
    AuthFlowInfo? flowInfo,
    LoginError? error,
    @Default(false) bool inProgress,
  }) = _ReauthorizeState;
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

sealed class ReauthorizeCubitEvent {}

class ReauthorizeSuccess extends ReauthorizeCubitEvent {}

class ReauthorizeFailure extends ReauthorizeCubitEvent {}
