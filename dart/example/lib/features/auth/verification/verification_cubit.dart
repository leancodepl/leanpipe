import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class VerificationCubit extends Cubit<VerificationState> {
  VerificationCubit({
    required this.kratosClient,
    required this.email,
    this.flowId,
    this.code,
  }) : super(
          VerificationInitial(email: email),
        );
  final KratosClient kratosClient;
  final String? email;
  final String? flowId;
  final String? code;

  Future<void> init() async {
    if (state case final VerificationInitial currState) {
      if (flowId case final String id) {
        emit(currState.copyWith(flowId: id));
        if (code case final String code) {
          await verify(code: code);
        }
      } else if (email case final String email) {
        final result = await kratosClient.getNewVerificationFlow(email: email);
        if (result is VerificationFlowResult) {
          emit(currState.copyWith(flowId: result.flowId));
        }
      }
    }
  }

  Future<void> verify({required String code}) async {
    if (state is! VerificationInitial) {
      emit(VerificationInitial(email: email, inProgress: true));
    } else {
      final currState = state as VerificationInitial;
      emit(currState.copyWith(inProgress: true));
    }
    final currState = state as VerificationInitial;
    final verificationFlowId = flowId ?? currState.flowId;
    if (verificationFlowId == null) {
      emit(VerificationError());
      return;
    }
    final result = await kratosClient.verifyAccount(
      flowId: verificationFlowId,
      code: code,
    );
    if (result is VerificationSuccessResult) {
      emit(VerificationSuccess());
    } else {
      emit(VerificationError());
    }
    return;
  }
}

sealed class VerificationState {}

class VerificationInitial extends VerificationState {
  VerificationInitial({
    this.inProgress = false,
    required this.email,
    this.flowId,
  });
  final bool inProgress;
  final String? email;
  final String? flowId;

  VerificationInitial copyWith({
    bool? inProgress,
    String? email,
    String? flowId,
  }) {
    return VerificationInitial(
      inProgress: inProgress ?? this.inProgress,
      email: email ?? this.email,
      flowId: flowId ?? this.flowId,
    );
  }
}

class VerificationSuccess extends VerificationState {}

class VerificationError extends VerificationState {}
