import 'package:app/resources/strings.dart';
import 'package:flutter/material.dart';

final emailRegex = RegExp(
  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
);

String? validateEmptyField(BuildContext context, String? value) {
  if (value == null || value.isEmpty) {
    return l10n(context).validator_field_empty;
  }
  return null;
}

String? validateEmail(BuildContext context, String? value) {
  if (value == null) {
    return null;
  }
  if (!emailRegex.hasMatch(value)) {
    return l10n(context).validator_email_wrong_format;
  }

  return null;
}

String? validatePasswordLength(BuildContext context, String? value) {
  if (value case final String value) {
    if (value.length < 8) {
      return l10n(context).validator_min_chars_password;
    }
  }
  return null;
}

String? validatePasswordsAreEqual(
  BuildContext context,
  String? password,
  String? repeatPassword,
) {
  if (password == null || repeatPassword == null) {
    return null;
  }

  if (password == repeatPassword) {
    return null;
  }

  return l10n(context).validator_passwords_not_match;
}
