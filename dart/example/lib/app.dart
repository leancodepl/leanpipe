import 'package:app/common/config/app_global_keys.dart';
import 'package:app/common/widgets/keyboard_dismisser.dart';
import 'package:app/design_system/styleguide/colors.dart';
import 'package:app/navigation/router.dart';
import 'package:app/resources/l10n/app_localizations.dart';
import 'package:debug_page/debug_page.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:provider/provider.dart';

class App extends HookWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final globalKeys = context.watch<AppGlobalKeys>();

    final router = useMemoized(
      () => createGoRouter(
        context,
        navigatorKey: globalKeys.navigatorKey,
      ),
    );

    return KeyboardDismisser(
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: DebugPageOverlay(
          controller: context.watch(),
          child: AppColorTheme(
            colors: AppColorThemes.light,
            child: MaterialApp.router(
              scaffoldMessengerKey: globalKeys.scaffoldMessengerKey,
              routerConfig: router,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
            ),
          ),
        ),
      ),
    );
  }
}
