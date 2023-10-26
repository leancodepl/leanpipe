import 'package:app/common/util/show_snack_bar.dart';
import 'package:app/resources/l10n/app_localizations.dart';
import 'package:app/resources/strings.dart';
import 'package:cqrs/cqrs.dart';
import 'package:flutter/material.dart';

class ErrorHandlingCqrsMiddleware extends CqrsMiddleware {
  const ErrorHandlingCqrsMiddleware(
    this._navigatorKey,
    this._scaffoldMessengerKey,
  );

  final GlobalKey<NavigatorState> _navigatorKey;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey;

  AppLocalizations? get _s => switch (_navigatorKey.currentContext) {
        final context? => l10n(context),
        _ => null,
      };

  @override
  Future<QueryResult<T>> handleQueryResult<T>(
    QueryResult<T> result,
  ) {
    if (result case QueryFailure()) {
      _handleError();
    }

    return Future.value(result);
  }

  @override
  Future<CommandResult> handleCommandResult(
    CommandResult result,
  ) {
    if (result case CommandFailure()) {
      _handleError();
    }

    return Future.value(result);
  }

  @override
  Future<OperationResult<T>> handleOperationResult<T>(
    OperationResult<T> result,
  ) {
    if (result case OperationFailure()) {
      _handleError();
    }

    return Future.value(result);
  }

  void _handleError() {
    if (_s case final s?) {
      showSnackBar(
        scaffoldMessengerKey: _scaffoldMessengerKey,
        text: s.error_handling_unknown,
      );
    }
  }
}
