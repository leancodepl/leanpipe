import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class RecoveryCubit extends Cubit<RecoveryState>
    with BlocPresentationMixin<RecoveryState, RecoveryCubitEvent> {
  RecoveryCubit({required this.kratosClient}) : super(const RecoveryInitial());

  final KratosClient kratosClient;

  Future<void> getRecoveryFlow() async {
    final result = await kratosClient.getRecoveryFlow();
    switch (result) {
      case RecoveryFlow _:
        emit(RecoveryEmailEntry(flowId: result.flowId));
      case RecoveryFlowError _:
        return;
    }
  }

  Future<void> sendEmail(String text) async {
    if (state case final RecoveryEmailEntry state) {
      emit(const RecoveryLoadingState());
      final result = await kratosClient.sendEmailRecoveryFlow(
        flowId: state.flowId,
        email: text,
      );
      if (result) {
        emit(RecoveryPinEntry(flowId: state.flowId));
      }
    }
  }

  Future<void> sendCode(String code) async {
    if (state case final RecoveryPinEntry state) {
      emit(const RecoveryLoadingState());

      final result = await kratosClient.sendCodeRecoveryFlow(
        flowId: state.flowId,
        code: code,
      );
      if (result is SettingsFlowResultError) {
        emit(const RecoveryFlowErrorState());
        emitPresentation(const ErrorEvent());
      } else {
        final data = result as SettingsFlowResultData;
        emit(
          RecoveryFlowPinResult(
            cookies: data.cookie,
            flowId: data.flowId,
            csrfToken: data.csrfToken,
          ),
        );
      }
    }
  }

  Future<void> setNewPassword({required String newPassword}) async {
    if (state case final RecoveryFlowPinResult state) {
      emit(const RecoveryLoadingState());

      final result = await kratosClient.sendNewPasswordSettingsFlow(
        flowId: state.flowId,
        newPassword: newPassword,
        cookieHeader: state.cookies,
        csrfToken: state.csrfToken,
      );
      if (result) {
        emit(const RecoverySuccessState());
        emitPresentation(const SuccessEvent());
      } else {
        emit(const RecoveryFlowErrorState());
        emitPresentation(const ErrorEvent());
      }
    }
  }
}

sealed class RecoveryState {
  const RecoveryState();
}

class RecoveryInitial extends RecoveryState {
  const RecoveryInitial();
}

class RecoveryEmailEntry extends RecoveryState {
  const RecoveryEmailEntry({required this.flowId});

  final String flowId;
}

class RecoveryPinEntry extends RecoveryState {
  const RecoveryPinEntry({required this.flowId});

  final String flowId;
}

class RecoveryFlowPinResult extends RecoveryState {
  const RecoveryFlowPinResult({
    required this.cookies,
    required this.flowId,
    required this.csrfToken,
  });

  final String cookies;
  final String flowId;
  final String csrfToken;
}

class RecoveryLoadingState extends RecoveryState {
  const RecoveryLoadingState();
}

class RecoverySuccessState extends RecoveryState {
  const RecoverySuccessState();
}

class RecoveryFlowErrorState extends RecoveryState {
  const RecoveryFlowErrorState();
}

sealed class RecoveryCubitEvent {}

class SuccessEvent implements RecoveryCubitEvent {
  const SuccessEvent();
}

class ErrorEvent implements RecoveryCubitEvent {
  const ErrorEvent();
}
