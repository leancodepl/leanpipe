import 'package:app/common/config/app_global_keys.dart';
import 'package:app/common/keys/keys.dart';
import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/common/widgets/keyboard_dismisser.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:app/navigation/router.dart';
import 'package:app/navigation/routes.dart';
import 'package:app/resources/l10n/app_localizations.dart';
import 'package:app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:leancode_hooks/leancode_hooks.dart';
import 'package:logging/logging.dart';
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
      child: MaterialApp.router(
        scaffoldMessengerKey: globalKeys.scaffoldMessengerKey,
        routerConfig: router,
        theme: AppTheme.light(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}

class HomePage extends Page<void> {
  const HomePage({
    super.key,
  });

  @override
  Route<void> createRoute(BuildContext context) => HomeRoute(this);
}

class HomeRoute extends MaterialPageRoute<void> {
  HomeRoute([HomePage? page])
      : super(
          settings: page,
          builder: (context) => const HomeScreen(),
        );
}

class HomeScreen extends HookWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);
    final colors = context.colors;

    final counterState = useState(0);

    return Scaffold(
      appBar: AppBar(
        title: AppText(s.common_app_name),
        leading: IconButton(
          icon: const Icon(Icons.person),
          onPressed: () {
            MenuRoute().go(context);
          },
        ),
        backgroundColor: colors.bgDefaultPrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const AppText(
              'You have pushed the button this many times:',
            ),
            AppText(
              '${counterState.value}',
              style: AppTextStyle.headlineM,
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AppPrimaryButton(
                onPressed: () {
                  Logger('Buggy TextButton').warning('some bug!');
                  throw Exception('Exception button clicked');
                },
                label: 'throw an exception',
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: K.counterButton,
        onPressed: () => counterState.value++,
        tooltip: 'Increment',
        backgroundColor: colors.bgInfoPrimary,
        foregroundColor: colors.fgInversePrimary,
        child: const Icon(Icons.add),
      ),
    );
  }
}
