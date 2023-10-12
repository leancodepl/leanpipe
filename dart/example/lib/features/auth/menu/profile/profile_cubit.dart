import 'package:app/features/auth/menu/menu_cubit.dart';
import 'package:bloc_presentation/bloc_presentation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class ProfileCubit extends Cubit<ProfileState>
    with BlocPresentationMixin<ProfileState, ProfileEvent> {
  ProfileCubit({
    required this.kratosClient,
    required this.menuCubit,
  }) : super(const ProfileInitial());

  final MenuCubit menuCubit;
  final KratosClient kratosClient;

  Future<void> updateTraits({
    required String email,
    required String name,
    required String surname,
  }) async {
    await menuCubit.getSettings();
    final menuState = menuCubit.state;

    if (menuState case final LoadedMenu state) {
      final profileTraits = [
        ProfileTrait(
          traitName: 'email',
          value: email,
        ),
        ProfileTrait(
          traitName: 'given_name',
          value: name,
        ),
        ProfileTrait(
          traitName: 'family_name',
          value: surname,
        ),
        ProfileTrait(
          traitName: 'regulations_accepted',
          value: true,
        ),
      ];

      final result = await kratosClient.updateTraits(
        traits: profileTraits,
        flowId: state.flowId,
      );

      switch (result) {
        case ProfileUpdateSuccess():
          await menuCubit.getSettings();
          emitPresentation(const SuccessEvent());

        case ProfileUpdateRequiresReauthorization():
          emitPresentation(const ProfileUpdateRequiresReauthentication());

        case ProfileUpdateFailure():
          emitPresentation(const ErrorEvent());
      }
    }
  }
}

sealed class ProfileState {
  const ProfileState();
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

/// Events

sealed class ProfileEvent {}

class SuccessEvent implements ProfileEvent {
  const SuccessEvent();
}

class ErrorEvent implements ProfileEvent {
  const ErrorEvent();
}

class ProfileUpdateRequiresReauthentication implements ProfileEvent {
  const ProfileUpdateRequiresReauthentication();
}
