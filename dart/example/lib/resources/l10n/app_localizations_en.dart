import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get common_app_name => 'LeanCode template';

  @override
  String get force_update_screen_title => 'Update app';

  @override
  String get force_update_screen_subtitle => 'New version is available, download it to continue';

  @override
  String get force_update_screen_updateButton => 'Update';

  @override
  String get suggest_update_dialog_title => 'Update app';

  @override
  String get suggest_update_dialog_subtitle => 'New version is available, you can download it now';

  @override
  String get suggest_update_dialog_updateButton => 'Update';

  @override
  String get suggest_update_dialog_cancelButton => 'Cancel';

  @override
  String get validator_field_empty => 'Field cannnot be empty';

  @override
  String get validator_email_wrong_format => 'Wrong format of email';

  @override
  String get validator_passwords_not_match => 'Passwords don\'t match';

  @override
  String get validator_min_chars_password => 'Passwords need to be at least 8 characters';

  @override
  String get enter_code_email => 'Enter the code from e-mail';

  @override
  String get error_verification => 'Error during verification';

  @override
  String get success_verification => 'Success verification';

  @override
  String get verification_page_title => 'Verification';

  @override
  String get login_page_recovery_button => 'Forgotten password';

  @override
  String get recovery_page_title => 'Recovery page';

  @override
  String get recovery_page_password_changed => 'Password has been changed';

  @override
  String get recovery_page_send => 'Send';

  @override
  String get recovery_page_pin_title => 'PIN';

  @override
  String get register => 'Register';

  @override
  String get continue_registration => 'Continue';

  @override
  String get terms_conditions_checkbox => 'I agree to the terms and conditions';

  @override
  String get login_button => 'Login';

  @override
  String get email_field => 'E-mail';

  @override
  String get password_field => 'Password';

  @override
  String get register_first_name_field => 'Given name';

  @override
  String get register_family_name_field => 'Family name';

  @override
  String get register_header => 'Register';

  @override
  String get login_header => 'Login';

  @override
  String field_error(Object errorId) {
    return 'Field contains errors: $errorId';
  }

  @override
  String get kratos_info_self_service_login_root => '';

  @override
  String get kratos_info_self_service_login => 'Sign in';

  @override
  String get kratos_info_self_service_login_with => 'Sign in with TODO ';

  @override
  String get kratos_info_self_service_login_re_auth => 'Please confirm this action by verifying that it is you';

  @override
  String get kratos_info_self_service_login_mfa => 'Please complete the second authentication challenge.';

  @override
  String get kratos_info_self_service_login_verify => 'Verify';

  @override
  String get kratos_info_self_service_login_totp_label => 'Authentication code';

  @override
  String get kratos_info_login_lookup_label => 'Backup recovery code';

  @override
  String get kratos_info_self_service_login_web_authn => 'Use security key';

  @override
  String get kratos_info_login_totp => 'Use Authenticator';

  @override
  String get kratos_info_login_lookup => 'Use backup recovery code';

  @override
  String get kratos_info_self_service_login_continue_web_authn => 'Continue with security key';

  @override
  String get kratos_info_self_service_login_web_authn_passwordless => 'Prepare your WebAuthn device (e.g. security key, biometrics scanner, ...) and press continue.';

  @override
  String get kratos_info_self_service_login_continue => 'Continue';

  @override
  String get kratos_info_self_service_logout => '';

  @override
  String get kratos_info_self_service_mfa => '';

  @override
  String get kratos_info_self_service_registration_root => '';

  @override
  String get kratos_info_self_service_registration => 'Sign up';

  @override
  String get kratos_info_self_service_registration_with => 'Sign up with TODO ';

  @override
  String get kratos_info_self_service_registration_continue => 'Continue';

  @override
  String get kratos_info_self_service_registration_register_web_authn => 'Sign up with security key';

  @override
  String get kratos_info_self_service_settings => '';

  @override
  String get kratos_info_self_service_settings_update_success => 'Your changes have been saved!';

  @override
  String get kratos_info_self_service_settings_update_link_oidc => 'Link TODO';

  @override
  String get kratos_info_self_service_settings_update_unlink_oidc => 'Unlink TODO ';

  @override
  String get kratos_info_self_service_settings_update_unlink_totp => 'Unlink TOTP Authenticator App';

  @override
  String get kratos_info_self_service_settings_totp_qrcode => 'Authenticator app QR code';

  @override
  String get kratos_info_self_service_settings_totp_secret => 'TODO';

  @override
  String get kratos_info_self_service_settings_reveal_lookup => 'Reveal backup recovery codes';

  @override
  String get kratos_info_self_service_settings_regenerate_lookup => 'Generate new backup recovery codes';

  @override
  String get kratos_info_self_service_settings_lookup_secret => 'TODO';

  @override
  String get kratos_info_self_service_settings_lookup_secret_label => 'This is your authenticator app secret. Use it if you can not scan the QR code.';

  @override
  String get kratos_info_self_service_settings_lookup_confirm => 'Confirm backup recovery codes';

  @override
  String get kratos_info_self_service_settings_register_web_authn => 'Add security key';

  @override
  String get kratos_info_self_service_settings_register_web_authn_display_name => 'Name of the security key';

  @override
  String get kratos_info_self_service_settings_lookup_secret_used => 'Secret was used at TODO';

  @override
  String get kratos_info_self_service_settings_lookup_secret_list => '';

  @override
  String get kratos_info_self_service_settings_disable_lookup => '';

  @override
  String get kratos_info_self_service_settings_totp_secret_label => 'If you are unable to use the QR code, please provide this activation key in the app:';

  @override
  String get kratos_info_self_service_settings_remove_web_authn => '';

  @override
  String get kratos_info_self_service_recovery => '';

  @override
  String get kratos_info_self_service_recovery_successful => 'You have successfully regained access to your account. Change your password in the form below.';

  @override
  String get kratos_info_self_service_recovery_email_sent => 'We have sent you an email with a link to reset your password to the email address you provided.';

  @override
  String get kratos_info_self_service_recovery_email_with_code_sent => 'We have sent an email containing a recovery code to the email address you provided.';

  @override
  String get kratos_info_node_label => '';

  @override
  String get kratos_info_node_label_input_password => 'Password';

  @override
  String get kratos_info_node_label_generated => '';

  @override
  String get kratos_info_node_label_save => '';

  @override
  String get kratos_info_node_label_id => '';

  @override
  String get kratos_info_node_label_submit => '';

  @override
  String get kratos_info_node_label_verify_otp => '';

  @override
  String get kratos_info_node_label_email => 'Email';

  @override
  String get kratos_info_node_label_resend_otp => 'Resend code';

  @override
  String get kratos_info_node_label_continue => '';

  @override
  String get kratos_info_node_label_recovery_code => 'Recovery code';

  @override
  String get kratos_info_node_label_verification_code => 'Verification code';

  @override
  String get kratos_info_self_service_verification => '';

  @override
  String get kratos_info_self_service_verification_email_sent => 'An email with a verification link has been sent to the address you provided';

  @override
  String get kratos_info_self_service_verification_successful => 'Your email address has been confirmed';

  @override
  String get kratos_info_self_service_verification_email_with_code_sent => 'An email with a verification code has been sent to the address you provided';

  @override
  String get kratos_error_validation => '';

  @override
  String get kratos_error_validation_generic => 'The field has an invalid format';

  @override
  String get kratos_error_validation_required => 'This field is required';

  @override
  String get kratos_error_validation_min_length => 'A minimum of 8 characters is required';

  @override
  String get kratos_error_validation_invalid_format => 'Invalid data format';

  @override
  String get kratos_error_validation_password_policy_violation => 'Min. 8 characters, Password must not be on the list of leaked passwords';

  @override
  String get kratos_error_validation_invalid_credentials => 'Invalid email address or password';

  @override
  String get kratos_error_validation_duplicate_credentials => 'An account with this login information already exists';

  @override
  String get kratos_error_validation_totp_verifier_wrong => 'The verification code you entered is invalid';

  @override
  String get kratos_error_validation_identifier_missing => '';

  @override
  String get kratos_error_validation_address_not_verified => '';

  @override
  String get kratos_error_validation_no_totp_device => '';

  @override
  String get kratos_error_validation_lookup_already_used => 'The recovery code has already been redeemed';

  @override
  String get kratos_error_validation_no_web_authn_device => '';

  @override
  String get kratos_error_validation_no_lookup => '';

  @override
  String get kratos_error_validation_such_no_web_authn_user => '';

  @override
  String get kratos_error_validation_lookup_invalid => '';

  @override
  String get kratos_error_validation_max_length => '';

  @override
  String get kratos_error_validation_minimum => '';

  @override
  String get kratos_error_validation_exclusive_minimum => '';

  @override
  String get kratos_error_validation_maximum => '';

  @override
  String get kratos_error_validation_exclusive_maximum => '';

  @override
  String get kratos_error_validation_multiple_of => '';

  @override
  String get kratos_error_validation_max_items => '';

  @override
  String get kratos_error_validation_min_items => '';

  @override
  String get kratos_error_validation_unique_items => '';

  @override
  String get kratos_error_validation_wrong_type => '';

  @override
  String get kratos_error_validation_duplicate_credentials_on_oidc_link => '';

  @override
  String get kratos_error_validation_login => '';

  @override
  String get kratos_error_validation_login_flow_expired => '';

  @override
  String get kratos_error_validation_login_no_strategy_found => '';

  @override
  String get kratos_error_validation_registration_no_strategy_found => '';

  @override
  String get kratos_error_validation_settings_no_strategy_found => '';

  @override
  String get kratos_error_validation_recovery_no_strategy_found => '';

  @override
  String get kratos_error_validation_verification_no_strategy_found => '';

  @override
  String get kratos_error_validation_registration => '';

  @override
  String get kratos_error_validation_registration_flow_expired => '';

  @override
  String get kratos_error_validation_settings => '';

  @override
  String get kratos_error_validation_settings_flow_expired => '';

  @override
  String get kratos_error_validation_recovery => '';

  @override
  String get kratos_error_validation_recovery_retry_success => 'The request has already been sent successfully and cannot be repeated';

  @override
  String get kratos_error_validation_recovery_state_failure => '';

  @override
  String get kratos_error_validation_recovery_missing_recovery_token => '';

  @override
  String get kratos_error_validation_recovery_token_invalid_or_already_used => 'The code is invalid or has already been used';

  @override
  String get kratos_error_validation_recovery_flow_expired => '';

  @override
  String get kratos_error_validation_recovery_code_invalid_or_already_used => 'The code is invalid or has already been redeemed';

  @override
  String get kratos_error_validation_verification => '';

  @override
  String get kratos_error_validation_verification_token_invalid_or_already_used => 'The code is invalid or has already been used';

  @override
  String get kratos_error_validation_verification_retry_success => '';

  @override
  String get kratos_error_validation_verification_state_failure => '';

  @override
  String get kratos_error_validation_verification_missing_verification_token => '';

  @override
  String get kratos_error_validation_verification_flow_expired => '';

  @override
  String get kratos_error_validation_verification_code_invalid_or_already_used => 'The code you entered is invalid or has already been used. try again';

  @override
  String get kratos_error_system => 'System error';

  @override
  String get kratos_error_system_generic => 'Generic error';

  @override
  String get register_with_apple_button => 'Register with Apple';

  @override
  String get register_with_google_button => 'Register with Google';

  @override
  String get register_with_facebook_button => 'Register with Facebook';

  @override
  String get error_handling_network => 'No internet connection, try again later';

  @override
  String get error_handling_authorization => 'No permission, go back';

  @override
  String get error_handling_unknown => 'Something went wrong, try again';

  @override
  String get register_unknown_error => 'Something went wrong, try again';

  @override
  String get login_unknown_error => 'Something went wrong, try again';

  @override
  String get social_traits_unknown_error => 'Something went wrong, try again';

  @override
  String get login_with_apple_button => 'Sign in with Apple';

  @override
  String get login_with_google_button => 'Sign in with Google';

  @override
  String get login_with_facebook_button => 'Sign in with Facebook';

  @override
  String get social_traits_cancel => 'Cancel';

  @override
  String get change_password_title => 'Change password';

  @override
  String get change_password_confirm_password => 'Confirm password';

  @override
  String get profile_my_profile => 'My profile';

  @override
  String get profile_password_change => 'Password change';

  @override
  String get profile_logout => 'Logout';

  @override
  String get profile_edit_form => 'Edit';

  @override
  String get profile_save_changes => 'Save';

  @override
  String get reauthorize_title => 'Authorization';

  @override
  String get reauthorize_info => 'To perform this operation you must log in again.';

  @override
  String get reauthorize_info_button => 'Next';

  @override
  String get home_screen_projects => 'Projects';

  @override
  String get home_screen_employees => 'Employees';

  @override
  String get project_details_screen_cannot_open_assignment => 'Employees list is either empty or has not been fetched';

  @override
  String get project_details_screen_unknown_id => 'Unknown project id';

  @override
  String assignment_screen_title(Object name) {
    return 'Assignment $name';
  }

  @override
  String get assignment_screen_assign => 'Assign employee';

  @override
  String get assignment_screen_unassign => 'Unassign employee';

  @override
  String get assignment_screen_pipe_logs => 'Pipe logs';

  @override
  String get assignment_screen_pipe_logs_placeholder => 'No logs so far...';
}
