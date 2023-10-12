import 'package:app/common/util/title_route_aware.dart';
import 'package:app/common/widgets/keyboard_dismisser.dart';
import 'package:app/resources/strings.dart';
import 'package:flutter/material.dart';

class AppScaffold extends StatelessWidget {
  const AppScaffold({
    super.key,
    this.title,
    required this.body,
    this.appBar,
    this.bottomNavigationBar,
  });

  final String? title;
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;

  @override
  Widget build(BuildContext context) {
    final s = l10n(context);

    return TitleRouteAware(
      title: title ?? s.common_app_name,
      child: KeyboardDismisser(
        child: Scaffold(
          appBar: appBar,
          body: body,
          bottomNavigationBar: bottomNavigationBar,
        ),
      ),
    );
  }
}
