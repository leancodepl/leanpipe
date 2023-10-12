import 'package:app/common/util/let.dart';
import 'package:app/features/auth/kratos/auth_bloc.dart';
import 'package:app/features/auth/kratos/common/trait.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

part 'social_cubit.freezed.dart';

class SocialCubit extends Cubit<SocialState>
    with BlocPresentationMixin<SocialState, SocialEvent> {
  SocialCubit({
    required this.kratosClient,
    required this.authCubit,
  }) : super(const SocialState.idle());

  final KratosClient kratosClient;
  final AuthCubit authCubit;

  Future<void> registerWithOidc(OidcProvider provider) async {
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

    final result = await kratosClient.registerWithOidc(
      provider: provider,
      returnTo: 'pl.leancode.template.tst://app',
    );

    _handleResponse(result, provider);
  }

  Future<void> finishRegisterWithOidc({
    required String email,
    required String givenName,
    required String familyName,
    required bool regulationsAccepted,
  }) async {
    var currentState = state;

    if (currentState is! SocialTraitsState) {
      return;
    }

    emit(
      currentState = currentState.copyWith(
        inProgress: true,
        fieldErrors: {},
        generalError: null,
      ),
    );

    final result = await kratosClient.registerWithOidc(
      provider: currentState.provider,
      returnTo: 'pl.leancode.template.tst://app',
      flowInfo: currentState.flowInfo,
      traits: {
        Trait.email.key: email,
        Trait.givenName.key: givenName,
        Trait.familyName.key: familyName,
        Trait.regulationsAccepted.key: regulationsAccepted,
      },
    );

    _handleResponse(result, currentState.provider);
  }

  void _handleResponse(
    RegistrationResponse response,
    OidcProvider provider,
  ) {
    switch (response) {
      case VerifyEmailResponse():
        emitPresentation(
          SocialVerifyEmailEvent(
            email: response.emailToVerify,
            flowId: response.flowId,
          ),
        );
      case SuccessResponse():
        authCubit.emit(LoggedIn());
        emitPresentation(const SocialSuccessEvent());
      case SocialRegisterFinishResponse():
        emit(
          SocialState.traitsStep(
            provider: provider,
            flowInfo: response.flowInfo,
            email: _getTraitValue(Trait.email, response.values) as String?,
            givenName:
                _getTraitValue(Trait.givenName, response.values) as String?,
            familyName:
                _getTraitValue(Trait.familyName, response.values) as String?,
            regulationsAccepted:
                _getTraitValue(Trait.regulationsAccepted, response.values)
                    as bool?,
          ),
        );
      case ErrorResponse(errors: final errors):
        emit(
          state.copyWith(
            fieldErrors: _mapTraitErrors(errors),
            generalError: _mapGeneralError(errors),
            inProgress: false,
          ),
        );
      case UnhandledStatusCodeError():
      case FailedRegistration():
        emit(
          state.copyWith(
            generalError: const SocialUnknownError(),
            inProgress: false,
          ),
        );
    }
  }

  dynamic _getTraitValue(Trait trait, List<(String, dynamic)> values) {
    return values
        .firstWhereOrNull((value) => value.$1 == 'traits.${trait.key}')
        ?.$2;
  }

  Map<String, KratosError> _mapTraitErrors(List<(String, KratosError)> errors) {
    return {
      for (final error
          in errors.reversed.where((error) => error.$1 != 'general'))
        error.$1: error.$2,
    };
  }

  SocialKratosGeneralError? _mapGeneralError(
    List<(String, KratosError)> errors,
  ) {
    return errors
        .firstWhereOrNull((error) => error.$1 == 'general')
        ?.let((error) => SocialKratosGeneralError(error.$2));
  }

  void cancel() {
    if (state.inProgress) {
      return;
    }

    emit(const SocialState.idle());
  }
}

@freezed
class SocialState with _$SocialState {
  const factory SocialState.idle({
    AuthFlowInfo? flowInfo,
    @Default({}) Map<String, KratosError> fieldErrors,
    SocialGeneralError? generalError,
    @Default(false) bool inProgress,
  }) = SocialIdleState;

  const factory SocialState.traitsStep({
    required OidcProvider provider,
    required String? email,
    required String? givenName,
    required String? familyName,
    required bool? regulationsAccepted,
    AuthFlowInfo? flowInfo,
    @Default({}) Map<String, KratosError> fieldErrors,
    SocialGeneralError? generalError,
    @Default(false) bool inProgress,
  }) = SocialTraitsState;
}

sealed class SocialGeneralError {
  const SocialGeneralError();
}

class SocialUnknownError extends SocialGeneralError {
  const SocialUnknownError();
}

class SocialKratosGeneralError extends SocialGeneralError {
  const SocialKratosGeneralError(this.error);

  final KratosError error;
}

sealed class SocialEvent {
  const SocialEvent();
}

class SocialSuccessEvent extends SocialEvent {
  const SocialSuccessEvent();
}

class SocialVerifyEmailEvent extends SocialEvent {
  const SocialVerifyEmailEvent({
    required this.email,
    required this.flowId,
  });

  final String? email;
  final String? flowId;
}
