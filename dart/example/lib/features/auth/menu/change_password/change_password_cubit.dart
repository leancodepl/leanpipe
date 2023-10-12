import 'package:app/features/auth/menu/menu_cubit.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class ChangePasswordCubit extends Cubit<ChangePasswordState>
    with BlocPresentationMixin<ChangePasswordState, ChangePasswordEvent> {
  ChangePasswordCubit({
    required this.kratosClient,
    required this.menuCubit,
  }) : super(const ChangePasswordInitial());

  final KratosClient kratosClient;
  final MenuCubit menuCubit;

  Future<void> changePassword({required String password}) async {
    await menuCubit.getSettings();
    final menuState = menuCubit.state;
    if (menuState case final LoadedMenu state) {
      emit(const ChangePasswordLoading());

      final result = await kratosClient.updatePassword(
        flowId: state.flowId,
        password: password,
      );
      
      switch (result) {
        case UpdateSuccess():
          emitPresentation(const SuccessEvent());
        case UpdateRequiresReauthorization():
          emitPresentation(const AuthorizationNeeded());
        case UpdateFailure():
          emitPresentation(const ErrorEvent());
      }
    } else {
      emitPresentation(const ErrorEvent());
    }
  }
}

sealed class ChangePasswordState {
  const ChangePasswordState();
}

class ChangePasswordInitial extends ChangePasswordState {
  const ChangePasswordInitial();
}

class ChangePasswordLoading extends ChangePasswordState {
  const ChangePasswordLoading();
}

/// Events

sealed class ChangePasswordEvent {
  const ChangePasswordEvent();
}

class SuccessEvent extends ChangePasswordEvent {
  const SuccessEvent();
}

class ErrorEvent extends ChangePasswordEvent {
  const ErrorEvent();
}

class AuthorizationNeeded extends ChangePasswordEvent {
  const AuthorizationNeeded();
}
