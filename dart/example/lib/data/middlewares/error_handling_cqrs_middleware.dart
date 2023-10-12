import 'package:app/common/util/colors_context_extension.dart';
import 'package:app/design_system_old/app_design_system.dart';
import 'package:app/resources/l10n/app_localizations.dart';
import 'package:app/resources/strings.dart';
import 'package:cqrs/cqrs.dart';
import 'package:flutter/material.dart'
    show ScaffoldMessengerState, SnackBar, SnackBarBehavior;
import 'package:flutter/widgets.dart';

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
    if (result case QueryFailure(:final error)) {
      switch (error) {
        case QueryError.network:
          _handleNetworkError();
        case QueryError.authentication:
          _handleAutheticationError();
        case QueryError.authorization:
          _handleAuthorizationError();
        case QueryError.unknown:
          _handleUnknownError();
        default:
      }
    }

    return Future.value(result);
  }

  @override
  Future<CommandResult> handleCommandResult(
    CommandResult result,
  ) {
    if (result case CommandFailure(:final error)) {
      switch (error) {
        case CommandError.network:
          _handleNetworkError();
        case CommandError.authentication:
          _handleAutheticationError();
        case CommandError.authorization:
          _handleAuthorizationError();
        case CommandError.unknown:
          _handleUnknownError();
        default:
      }
    }

    return Future.value(result);
  }

  @override
  Future<OperationResult<T>> handleOperationResult<T>(
    OperationResult<T> result,
  ) {
    if (result case OperationFailure(:final error)) {
      switch (error) {
        case OperationError.network:
          _handleNetworkError();
        case OperationError.authentication:
          _handleAutheticationError();
        case OperationError.authorization:
          _handleAuthorizationError();
        case OperationError.unknown:
          _handleUnknownError();
        default:
      }
    }

    return Future.value(result);
  }

  void _handleNetworkError() {
    if (_s case final s?) {
      _showSnackBar(s.error_handling_network);
    }
  }

  void _handleAutheticationError() {
    // TODO: Call logout() here
  }

  void _handleAuthorizationError() {
    if (_s case final s?) {
      _showSnackBar(s.error_handling_authorization);
    }

    // TODO: Navigate to main screen
  }

  void _handleUnknownError() {
    if (_s case final s?) {
      _showSnackBar(s.error_handling_unknown);
    }
  }

  void _showSnackBar(String text) {
    final messengerState = _scaffoldMessengerKey.currentState;
    if (messengerState == null) {
      return;
    }

    final colors = messengerState.context.colors;

    final snackBar = SnackBar(
      margin: const EdgeInsets.all(24),
      backgroundColor: colors.bgDefaultPrimary,
      content: AppText(text, style: AppTextStyle.button),
      behavior: SnackBarBehavior.floating,
    );

    messengerState.showSnackBar(snackBar);
  }
}
