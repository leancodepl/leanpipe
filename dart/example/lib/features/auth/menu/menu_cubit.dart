import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

class MenuCubit extends Cubit<MenuState> {
  MenuCubit({required this.kratosClient}) : super(const LoadingMenu());

  final KratosClient kratosClient;

  Future<void> getSettings() async {
    final profile = await kratosClient.getSettingsFlow();
    if (profile is! ProfileData) {
      emit(const ErrorLoadingMenu());
      return;
    }
    emit(LoadedMenu(flowId: profile.flowId, traits: profile.traits));
  }
}

sealed class MenuState {
  const MenuState();
}

class LoadingMenu extends MenuState {
  const LoadingMenu();
}

class LoadedMenu extends MenuState {
  const LoadedMenu({required this.flowId, required this.traits});

  final String flowId;
  final List<ProfileTrait> traits;
}

class ErrorLoadingMenu extends MenuState {
  const ErrorLoadingMenu();
}

extension LoadedMenuExtensions on LoadedMenu {
  String? _getTrait(String trait) {
    return traits
        .firstWhereOrNull(
          (trait) => trait.traitName == 'given_name',
        )
        ?.value as String?;
  }

  String? get givenName {
    return _getTrait('given_name');
  }

  String? get familyName {
    return _getTrait('family_name');
  }

  String? get email {
    return _getTrait('email');
  }

  String get initials {
    return (givenName?[0] ?? '') + (familyName?[0] ?? '');
  }
}

extension MenuCubitExtension on MenuCubit {
  String? get email {
    return switch (state) {
      final LoadedMenu state => state.email,
      _ => null,
    };
  }

  String? get familyName {
    return switch (state) {
      final LoadedMenu state => state.familyName,
      _ => null,
    };
  }

  String? get givenName {
    return switch (state) {
      final LoadedMenu state => state.givenName,
      _ => null,
    };
  }
}
