import 'package:app/common/util/let.dart';
import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:app/features/auth/kratos/common/trait.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

part 'register_cubit.freezed.dart';

class RegisterCubit extends Cubit<RegisterState>
    with BlocPresentationMixin<RegisterState, RegisterEvent> {
  RegisterCubit({
    required this.kratosClient,
    required this.authCubit,
  }) : super(const RegisterState());

  final KratosClient kratosClient;
  final AuthCubit authCubit;

  Future<void> registerWithPassword({
    required String email,
    required String password,
    required String givenName,
    required String familyName,
    required bool regulationsAccepted,
  }) async {
    var currentState = state;

    if (currentState.inProgress) {
      return;
    }

    emit(
      currentState = currentState.copyWith(
        inProgress: true,
        fieldErrors: {},
        generalError: null,
      ),
    );

    final result = await kratosClient.registerWithPassword(
      password: password,
      traits: {
        Trait.email.key: email,
        Trait.givenName.key: givenName,
        Trait.familyName.key: familyName,
        Trait.regulationsAccepted.key: regulationsAccepted,
      },
    );

    switch (result) {
      case VerifyEmailResponse():
        emitPresentation(
          RegisterVerifyEmailEvent(
            email: result.emailToVerify,
            flowId: result.flowId,
          ),
        );
      case SuccessResponse():
        authCubit.emit(LoggedIn());
        emitPresentation(const RegisterSuccessEvent());
      case ErrorResponse(errors: final errors):
        emit(
          currentState = currentState.copyWith(
            fieldErrors: _mapTraitErrors(errors),
            generalError: _mapGeneralError(errors),
            inProgress: false,
          ),
        );
      case UnhandledStatusCodeError():
      case FailedRegistration():
      case SocialRegisterFinishResponse():
        emit(
          currentState = currentState.copyWith(
            generalError: const RegisterUnknownError(),
            inProgress: false,
          ),
        );
    }
  }

  Map<String, KratosError> _mapTraitErrors(List<(String, KratosError)> errors) {
    return {
      for (final error
          in errors.reversed.where((error) => error.$1 != 'general'))
        error.$1: error.$2,
    };
  }

  RegisterKratosGeneralError? _mapGeneralError(
    List<(String, KratosError)> errors,
  ) {
    return errors
        .firstWhereOrNull((error) => error.$1 == 'general')
        ?.let((error) => RegisterKratosGeneralError(error.$2));
  }
}

@freezed
class RegisterState with _$RegisterState {
  const factory RegisterState({
    AuthFlowInfo? flowInfo,
    @Default({}) Map<String, KratosError> fieldErrors,
    RegisterGeneralError? generalError,
    @Default(false) bool inProgress,
  }) = _RegisterState;
}

sealed class RegisterGeneralError {
  const RegisterGeneralError();
}

class RegisterUnknownError extends RegisterGeneralError {
  const RegisterUnknownError();
}

class RegisterKratosGeneralError extends RegisterGeneralError {
  const RegisterKratosGeneralError(this.error);

  final KratosError error;
}

sealed class RegisterEvent {
  const RegisterEvent();
}

class RegisterSuccessEvent extends RegisterEvent {
  const RegisterSuccessEvent();
}

class RegisterVerifyEmailEvent extends RegisterEvent {
  const RegisterVerifyEmailEvent({
    required this.email,
    required this.flowId,
  });

  final String? email;
  final String? flowId;
}
