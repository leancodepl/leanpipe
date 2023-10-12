import 'package:app/common/util/colors_context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class TitleRouteObserver extends RouteObserver<ModalRoute<void>> {}

class TitleRouteAware extends StatefulWidget {
  const TitleRouteAware({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  State<TitleRouteAware> createState() => _TitleRouteAwareState();
}

class _TitleRouteAwareState extends State<TitleRouteAware> with RouteAware {
  late TitleRouteObserver _titleRouteObserver;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    // this feature is reasonable to use in routes only
    if (route != null) {
      _titleRouteObserver = context.read<TitleRouteObserver>()
        ..subscribe(this, route);
    }
  }

  @override
  void dispose() {
    _titleRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  @override
  void didPush() {
    _setTitle();
    super.didPush();
  }

  @override
  void didPopNext() {
    _setTitle();
    super.didPopNext();
  }

  void _setTitle() {
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: widget.title,
        primaryColor: context.colors.transparent.value,
      ),
    );
  }
}
