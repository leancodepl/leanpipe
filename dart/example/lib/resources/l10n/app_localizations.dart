import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pl.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen_l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pl')
  ];

  /// No description provided for @common_app_name.
  ///
  /// In en, this message translates to:
  /// **'LeanCode template'**
  String get common_app_name;

  /// No description provided for @force_update_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Update app'**
  String get force_update_screen_title;

  /// No description provided for @force_update_screen_subtitle.
  ///
  /// In en, this message translates to:
  /// **'New version is available, download it to continue'**
  String get force_update_screen_subtitle;

  /// No description provided for @force_update_screen_updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get force_update_screen_updateButton;

  /// No description provided for @suggest_update_dialog_title.
  ///
  /// In en, this message translates to:
  /// **'Update app'**
  String get suggest_update_dialog_title;

  /// No description provided for @suggest_update_dialog_subtitle.
  ///
  /// In en, this message translates to:
  /// **'New version is available, you can download it now'**
  String get suggest_update_dialog_subtitle;

  /// No description provided for @suggest_update_dialog_updateButton.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get suggest_update_dialog_updateButton;

  /// No description provided for @suggest_update_dialog_cancelButton.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get suggest_update_dialog_cancelButton;

  /// No description provided for @validator_field_empty.
  ///
  /// In en, this message translates to:
  /// **'Field cannnot be empty'**
  String get validator_field_empty;

  /// No description provided for @validator_email_wrong_format.
  ///
  /// In en, this message translates to:
  /// **'Wrong format of email'**
  String get validator_email_wrong_format;

  /// No description provided for @validator_passwords_not_match.
  ///
  /// In en, this message translates to:
  /// **'Passwords don\'t match'**
  String get validator_passwords_not_match;

  /// No description provided for @validator_min_chars_password.
  ///
  /// In en, this message translates to:
  /// **'Passwords need to be at least 8 characters'**
  String get validator_min_chars_password;

  /// No description provided for @enter_code_email.
  ///
  /// In en, this message translates to:
  /// **'Enter the code from e-mail'**
  String get enter_code_email;

  /// No description provided for @error_verification.
  ///
  /// In en, this message translates to:
  /// **'Error during verification'**
  String get error_verification;

  /// No description provided for @success_verification.
  ///
  /// In en, this message translates to:
  /// **'Success verification'**
  String get success_verification;

  /// No description provided for @verification_page_title.
  ///
  /// In en, this message translates to:
  /// **'Verification'**
  String get verification_page_title;

  /// No description provided for @login_page_recovery_button.
  ///
  /// In en, this message translates to:
  /// **'Forgotten password'**
  String get login_page_recovery_button;

  /// No description provided for @recovery_page_title.
  ///
  /// In en, this message translates to:
  /// **'Recovery page'**
  String get recovery_page_title;

  /// No description provided for @recovery_page_password_changed.
  ///
  /// In en, this message translates to:
  /// **'Password has been changed'**
  String get recovery_page_password_changed;

  /// No description provided for @recovery_page_send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get recovery_page_send;

  /// No description provided for @recovery_page_pin_title.
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get recovery_page_pin_title;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @continue_registration.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_registration;

  /// No description provided for @terms_conditions_checkbox.
  ///
  /// In en, this message translates to:
  /// **'I agree to the terms and conditions'**
  String get terms_conditions_checkbox;

  /// No description provided for @login_button.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @email_field.
  ///
  /// In en, this message translates to:
  /// **'E-mail'**
  String get email_field;

  /// No description provided for @password_field.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password_field;

  /// No description provided for @register_first_name_field.
  ///
  /// In en, this message translates to:
  /// **'Given name'**
  String get register_first_name_field;

  /// No description provided for @register_family_name_field.
  ///
  /// In en, this message translates to:
  /// **'Family name'**
  String get register_family_name_field;

  /// No description provided for @register_header.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register_header;

  /// No description provided for @login_header.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login_header;

  /// No description provided for @field_error.
  ///
  /// In en, this message translates to:
  /// **'Field contains errors: {errorId}'**
  String field_error(Object errorId);

  /// No description provided for @kratos_info_self_service_login_root.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_login_root;

  /// No description provided for @kratos_info_self_service_login.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get kratos_info_self_service_login;

  /// No description provided for @kratos_info_self_service_login_with.
  ///
  /// In en, this message translates to:
  /// **'Sign in with TODO '**
  String get kratos_info_self_service_login_with;

  /// No description provided for @kratos_info_self_service_login_re_auth.
  ///
  /// In en, this message translates to:
  /// **'Please confirm this action by verifying that it is you'**
  String get kratos_info_self_service_login_re_auth;

  /// No description provided for @kratos_info_self_service_login_mfa.
  ///
  /// In en, this message translates to:
  /// **'Please complete the second authentication challenge.'**
  String get kratos_info_self_service_login_mfa;

  /// No description provided for @kratos_info_self_service_login_verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get kratos_info_self_service_login_verify;

  /// No description provided for @kratos_info_self_service_login_totp_label.
  ///
  /// In en, this message translates to:
  /// **'Authentication code'**
  String get kratos_info_self_service_login_totp_label;

  /// No description provided for @kratos_info_login_lookup_label.
  ///
  /// In en, this message translates to:
  /// **'Backup recovery code'**
  String get kratos_info_login_lookup_label;

  /// No description provided for @kratos_info_self_service_login_web_authn.
  ///
  /// In en, this message translates to:
  /// **'Use security key'**
  String get kratos_info_self_service_login_web_authn;

  /// No description provided for @kratos_info_login_totp.
  ///
  /// In en, this message translates to:
  /// **'Use Authenticator'**
  String get kratos_info_login_totp;

  /// No description provided for @kratos_info_login_lookup.
  ///
  /// In en, this message translates to:
  /// **'Use backup recovery code'**
  String get kratos_info_login_lookup;

  /// No description provided for @kratos_info_self_service_login_continue_web_authn.
  ///
  /// In en, this message translates to:
  /// **'Continue with security key'**
  String get kratos_info_self_service_login_continue_web_authn;

  /// No description provided for @kratos_info_self_service_login_web_authn_passwordless.
  ///
  /// In en, this message translates to:
  /// **'Prepare your WebAuthn device (e.g. security key, biometrics scanner, ...) and press continue.'**
  String get kratos_info_self_service_login_web_authn_passwordless;

  /// No description provided for @kratos_info_self_service_login_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get kratos_info_self_service_login_continue;

  /// No description provided for @kratos_info_self_service_logout.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_logout;

  /// No description provided for @kratos_info_self_service_mfa.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_mfa;

  /// No description provided for @kratos_info_self_service_registration_root.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_registration_root;

  /// No description provided for @kratos_info_self_service_registration.
  ///
  /// In en, this message translates to:
  /// **'Sign up'**
  String get kratos_info_self_service_registration;

  /// No description provided for @kratos_info_self_service_registration_with.
  ///
  /// In en, this message translates to:
  /// **'Sign up with TODO '**
  String get kratos_info_self_service_registration_with;

  /// No description provided for @kratos_info_self_service_registration_continue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get kratos_info_self_service_registration_continue;

  /// No description provided for @kratos_info_self_service_registration_register_web_authn.
  ///
  /// In en, this message translates to:
  /// **'Sign up with security key'**
  String get kratos_info_self_service_registration_register_web_authn;

  /// No description provided for @kratos_info_self_service_settings.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings;

  /// No description provided for @kratos_info_self_service_settings_update_success.
  ///
  /// In en, this message translates to:
  /// **'Your changes have been saved!'**
  String get kratos_info_self_service_settings_update_success;

  /// No description provided for @kratos_info_self_service_settings_update_link_oidc.
  ///
  /// In en, this message translates to:
  /// **'Link TODO'**
  String get kratos_info_self_service_settings_update_link_oidc;

  /// No description provided for @kratos_info_self_service_settings_update_unlink_oidc.
  ///
  /// In en, this message translates to:
  /// **'Unlink TODO '**
  String get kratos_info_self_service_settings_update_unlink_oidc;

  /// No description provided for @kratos_info_self_service_settings_update_unlink_totp.
  ///
  /// In en, this message translates to:
  /// **'Unlink TOTP Authenticator App'**
  String get kratos_info_self_service_settings_update_unlink_totp;

  /// No description provided for @kratos_info_self_service_settings_totp_qrcode.
  ///
  /// In en, this message translates to:
  /// **'Authenticator app QR code'**
  String get kratos_info_self_service_settings_totp_qrcode;

  /// No description provided for @kratos_info_self_service_settings_totp_secret.
  ///
  /// In en, this message translates to:
  /// **'TODO'**
  String get kratos_info_self_service_settings_totp_secret;

  /// No description provided for @kratos_info_self_service_settings_reveal_lookup.
  ///
  /// In en, this message translates to:
  /// **'Reveal backup recovery codes'**
  String get kratos_info_self_service_settings_reveal_lookup;

  /// No description provided for @kratos_info_self_service_settings_regenerate_lookup.
  ///
  /// In en, this message translates to:
  /// **'Generate new backup recovery codes'**
  String get kratos_info_self_service_settings_regenerate_lookup;

  /// No description provided for @kratos_info_self_service_settings_lookup_secret.
  ///
  /// In en, this message translates to:
  /// **'TODO'**
  String get kratos_info_self_service_settings_lookup_secret;

  /// No description provided for @kratos_info_self_service_settings_lookup_secret_label.
  ///
  /// In en, this message translates to:
  /// **'This is your authenticator app secret. Use it if you can not scan the QR code.'**
  String get kratos_info_self_service_settings_lookup_secret_label;

  /// No description provided for @kratos_info_self_service_settings_lookup_confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm backup recovery codes'**
  String get kratos_info_self_service_settings_lookup_confirm;

  /// No description provided for @kratos_info_self_service_settings_register_web_authn.
  ///
  /// In en, this message translates to:
  /// **'Add security key'**
  String get kratos_info_self_service_settings_register_web_authn;

  /// No description provided for @kratos_info_self_service_settings_register_web_authn_display_name.
  ///
  /// In en, this message translates to:
  /// **'Name of the security key'**
  String get kratos_info_self_service_settings_register_web_authn_display_name;

  /// No description provided for @kratos_info_self_service_settings_lookup_secret_used.
  ///
  /// In en, this message translates to:
  /// **'Secret was used at TODO'**
  String get kratos_info_self_service_settings_lookup_secret_used;

  /// No description provided for @kratos_info_self_service_settings_lookup_secret_list.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_lookup_secret_list;

  /// No description provided for @kratos_info_self_service_settings_disable_lookup.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_disable_lookup;

  /// No description provided for @kratos_info_self_service_settings_totp_secret_label.
  ///
  /// In en, this message translates to:
  /// **'If you are unable to use the QR code, please provide this activation key in the app:'**
  String get kratos_info_self_service_settings_totp_secret_label;

  /// No description provided for @kratos_info_self_service_settings_remove_web_authn.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_remove_web_authn;

  /// No description provided for @kratos_info_self_service_recovery.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_recovery;

  /// No description provided for @kratos_info_self_service_recovery_successful.
  ///
  /// In en, this message translates to:
  /// **'You have successfully regained access to your account. Change your password in the form below.'**
  String get kratos_info_self_service_recovery_successful;

  /// No description provided for @kratos_info_self_service_recovery_email_sent.
  ///
  /// In en, this message translates to:
  /// **'We have sent you an email with a link to reset your password to the email address you provided.'**
  String get kratos_info_self_service_recovery_email_sent;

  /// No description provided for @kratos_info_self_service_recovery_email_with_code_sent.
  ///
  /// In en, this message translates to:
  /// **'We have sent an email containing a recovery code to the email address you provided.'**
  String get kratos_info_self_service_recovery_email_with_code_sent;

  /// No description provided for @kratos_info_node_label.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_node_label;

  /// No description provided for @kratos_info_node_label_input_password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get kratos_info_node_label_input_password;

  /// No description provided for @kratos_info_node_label_generated.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_node_label_generated;

  /// No description provided for @kratos_info_node_label_save.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_node_label_save;

  /// No description provided for @kratos_info_node_label_id.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_node_label_id;

  /// No description provided for @kratos_info_node_label_submit.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_node_label_submit;

  /// No description provided for @kratos_info_node_label_verify_otp.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_node_label_verify_otp;

  /// No description provided for @kratos_info_node_label_email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get kratos_info_node_label_email;

  /// No description provided for @kratos_info_node_label_resend_otp.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get kratos_info_node_label_resend_otp;

  /// No description provided for @kratos_info_node_label_continue.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_node_label_continue;

  /// No description provided for @kratos_info_node_label_recovery_code.
  ///
  /// In en, this message translates to:
  /// **'Recovery code'**
  String get kratos_info_node_label_recovery_code;

  /// No description provided for @kratos_info_node_label_verification_code.
  ///
  /// In en, this message translates to:
  /// **'Verification code'**
  String get kratos_info_node_label_verification_code;

  /// No description provided for @kratos_info_self_service_verification.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_info_self_service_verification;

  /// No description provided for @kratos_info_self_service_verification_email_sent.
  ///
  /// In en, this message translates to:
  /// **'An email with a verification link has been sent to the address you provided'**
  String get kratos_info_self_service_verification_email_sent;

  /// No description provided for @kratos_info_self_service_verification_successful.
  ///
  /// In en, this message translates to:
  /// **'Your email address has been confirmed'**
  String get kratos_info_self_service_verification_successful;

  /// No description provided for @kratos_info_self_service_verification_email_with_code_sent.
  ///
  /// In en, this message translates to:
  /// **'An email with a verification code has been sent to the address you provided'**
  String get kratos_info_self_service_verification_email_with_code_sent;

  /// No description provided for @kratos_error_validation.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation;

  /// No description provided for @kratos_error_validation_generic.
  ///
  /// In en, this message translates to:
  /// **'The field has an invalid format'**
  String get kratos_error_validation_generic;

  /// No description provided for @kratos_error_validation_required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get kratos_error_validation_required;

  /// No description provided for @kratos_error_validation_min_length.
  ///
  /// In en, this message translates to:
  /// **'A minimum of 8 characters is required'**
  String get kratos_error_validation_min_length;

  /// No description provided for @kratos_error_validation_invalid_format.
  ///
  /// In en, this message translates to:
  /// **'Invalid data format'**
  String get kratos_error_validation_invalid_format;

  /// No description provided for @kratos_error_validation_password_policy_violation.
  ///
  /// In en, this message translates to:
  /// **'Min. 8 characters, Password must not be on the list of leaked passwords'**
  String get kratos_error_validation_password_policy_violation;

  /// No description provided for @kratos_error_validation_invalid_credentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email address or password'**
  String get kratos_error_validation_invalid_credentials;

  /// No description provided for @kratos_error_validation_duplicate_credentials.
  ///
  /// In en, this message translates to:
  /// **'An account with this login information already exists'**
  String get kratos_error_validation_duplicate_credentials;

  /// No description provided for @kratos_error_validation_totp_verifier_wrong.
  ///
  /// In en, this message translates to:
  /// **'The verification code you entered is invalid'**
  String get kratos_error_validation_totp_verifier_wrong;

  /// No description provided for @kratos_error_validation_identifier_missing.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_identifier_missing;

  /// No description provided for @kratos_error_validation_address_not_verified.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_address_not_verified;

  /// No description provided for @kratos_error_validation_no_totp_device.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_no_totp_device;

  /// No description provided for @kratos_error_validation_lookup_already_used.
  ///
  /// In en, this message translates to:
  /// **'The recovery code has already been redeemed'**
  String get kratos_error_validation_lookup_already_used;

  /// No description provided for @kratos_error_validation_no_web_authn_device.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_no_web_authn_device;

  /// No description provided for @kratos_error_validation_no_lookup.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_no_lookup;

  /// No description provided for @kratos_error_validation_such_no_web_authn_user.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_such_no_web_authn_user;

  /// No description provided for @kratos_error_validation_lookup_invalid.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_lookup_invalid;

  /// No description provided for @kratos_error_validation_max_length.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_max_length;

  /// No description provided for @kratos_error_validation_minimum.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_minimum;

  /// No description provided for @kratos_error_validation_exclusive_minimum.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_exclusive_minimum;

  /// No description provided for @kratos_error_validation_maximum.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_maximum;

  /// No description provided for @kratos_error_validation_exclusive_maximum.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_exclusive_maximum;

  /// No description provided for @kratos_error_validation_multiple_of.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_multiple_of;

  /// No description provided for @kratos_error_validation_max_items.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_max_items;

  /// No description provided for @kratos_error_validation_min_items.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_min_items;

  /// No description provided for @kratos_error_validation_unique_items.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_unique_items;

  /// No description provided for @kratos_error_validation_wrong_type.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_wrong_type;

  /// No description provided for @kratos_error_validation_duplicate_credentials_on_oidc_link.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_duplicate_credentials_on_oidc_link;

  /// No description provided for @kratos_error_validation_login.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_login;

  /// No description provided for @kratos_error_validation_login_flow_expired.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_login_flow_expired;

  /// No description provided for @kratos_error_validation_login_no_strategy_found.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_login_no_strategy_found;

  /// No description provided for @kratos_error_validation_registration_no_strategy_found.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_registration_no_strategy_found;

  /// No description provided for @kratos_error_validation_settings_no_strategy_found.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_settings_no_strategy_found;

  /// No description provided for @kratos_error_validation_recovery_no_strategy_found.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery_no_strategy_found;

  /// No description provided for @kratos_error_validation_verification_no_strategy_found.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_no_strategy_found;

  /// No description provided for @kratos_error_validation_registration.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_registration;

  /// No description provided for @kratos_error_validation_registration_flow_expired.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_registration_flow_expired;

  /// No description provided for @kratos_error_validation_settings.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_settings;

  /// No description provided for @kratos_error_validation_settings_flow_expired.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_settings_flow_expired;

  /// No description provided for @kratos_error_validation_recovery.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery;

  /// No description provided for @kratos_error_validation_recovery_retry_success.
  ///
  /// In en, this message translates to:
  /// **'The request has already been sent successfully and cannot be repeated'**
  String get kratos_error_validation_recovery_retry_success;

  /// No description provided for @kratos_error_validation_recovery_state_failure.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery_state_failure;

  /// No description provided for @kratos_error_validation_recovery_missing_recovery_token.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery_missing_recovery_token;

  /// No description provided for @kratos_error_validation_recovery_token_invalid_or_already_used.
  ///
  /// In en, this message translates to:
  /// **'The code is invalid or has already been used'**
  String get kratos_error_validation_recovery_token_invalid_or_already_used;

  /// No description provided for @kratos_error_validation_recovery_flow_expired.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery_flow_expired;

  /// No description provided for @kratos_error_validation_recovery_code_invalid_or_already_used.
  ///
  /// In en, this message translates to:
  /// **'The code is invalid or has already been redeemed'**
  String get kratos_error_validation_recovery_code_invalid_or_already_used;

  /// No description provided for @kratos_error_validation_verification.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_verification;

  /// No description provided for @kratos_error_validation_verification_token_invalid_or_already_used.
  ///
  /// In en, this message translates to:
  /// **'The code is invalid or has already been used'**
  String get kratos_error_validation_verification_token_invalid_or_already_used;

  /// No description provided for @kratos_error_validation_verification_retry_success.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_retry_success;

  /// No description provided for @kratos_error_validation_verification_state_failure.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_state_failure;

  /// No description provided for @kratos_error_validation_verification_missing_verification_token.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_missing_verification_token;

  /// No description provided for @kratos_error_validation_verification_flow_expired.
  ///
  /// In en, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_flow_expired;

  /// No description provided for @kratos_error_validation_verification_code_invalid_or_already_used.
  ///
  /// In en, this message translates to:
  /// **'The code you entered is invalid or has already been used. try again'**
  String get kratos_error_validation_verification_code_invalid_or_already_used;

  /// No description provided for @kratos_error_system.
  ///
  /// In en, this message translates to:
  /// **'System error'**
  String get kratos_error_system;

  /// No description provided for @kratos_error_system_generic.
  ///
  /// In en, this message translates to:
  /// **'Generic error'**
  String get kratos_error_system_generic;

  /// No description provided for @register_with_apple_button.
  ///
  /// In en, this message translates to:
  /// **'Register with Apple'**
  String get register_with_apple_button;

  /// No description provided for @register_with_google_button.
  ///
  /// In en, this message translates to:
  /// **'Register with Google'**
  String get register_with_google_button;

  /// No description provided for @register_with_facebook_button.
  ///
  /// In en, this message translates to:
  /// **'Register with Facebook'**
  String get register_with_facebook_button;

  /// No description provided for @error_handling_network.
  ///
  /// In en, this message translates to:
  /// **'No internet connection, try again later'**
  String get error_handling_network;

  /// No description provided for @error_handling_authorization.
  ///
  /// In en, this message translates to:
  /// **'No permission, go back'**
  String get error_handling_authorization;

  /// No description provided for @error_handling_unknown.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, try again'**
  String get error_handling_unknown;

  /// No description provided for @register_unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, try again'**
  String get register_unknown_error;

  /// No description provided for @login_unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, try again'**
  String get login_unknown_error;

  /// No description provided for @social_traits_unknown_error.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong, try again'**
  String get social_traits_unknown_error;

  /// No description provided for @login_with_apple_button.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get login_with_apple_button;

  /// No description provided for @login_with_google_button.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get login_with_google_button;

  /// No description provided for @login_with_facebook_button.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Facebook'**
  String get login_with_facebook_button;

  /// No description provided for @social_traits_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get social_traits_cancel;

  /// No description provided for @change_password_title.
  ///
  /// In en, this message translates to:
  /// **'Change password'**
  String get change_password_title;

  /// No description provided for @change_password_confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get change_password_confirm_password;

  /// No description provided for @profile_my_profile.
  ///
  /// In en, this message translates to:
  /// **'My profile'**
  String get profile_my_profile;

  /// No description provided for @profile_password_change.
  ///
  /// In en, this message translates to:
  /// **'Password change'**
  String get profile_password_change;

  /// No description provided for @profile_logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get profile_logout;

  /// No description provided for @profile_edit_form.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get profile_edit_form;

  /// No description provided for @profile_save_changes.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get profile_save_changes;

  /// No description provided for @reauthorize_title.
  ///
  /// In en, this message translates to:
  /// **'Authorization'**
  String get reauthorize_title;

  /// No description provided for @reauthorize_info.
  ///
  /// In en, this message translates to:
  /// **'To perform this operation you must log in again.'**
  String get reauthorize_info;

  /// No description provided for @reauthorize_info_button.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get reauthorize_info_button;

  /// No description provided for @home_screen_projects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get home_screen_projects;

  /// No description provided for @home_screen_employees.
  ///
  /// In en, this message translates to:
  /// **'Employees'**
  String get home_screen_employees;

  /// No description provided for @project_details_screen_cannot_open_assignment.
  ///
  /// In en, this message translates to:
  /// **'Employees list is either empty or has not been fetched'**
  String get project_details_screen_cannot_open_assignment;

  /// No description provided for @project_details_screen_unknown_id.
  ///
  /// In en, this message translates to:
  /// **'Unknown project id'**
  String get project_details_screen_unknown_id;

  /// No description provided for @assignment_screen_title.
  ///
  /// In en, this message translates to:
  /// **'Assignment {name}'**
  String assignment_screen_title(Object name);

  /// No description provided for @assignment_screen_assign.
  ///
  /// In en, this message translates to:
  /// **'Assign employee'**
  String get assignment_screen_assign;

  /// No description provided for @assignment_screen_unassign.
  ///
  /// In en, this message translates to:
  /// **'Unassign employee'**
  String get assignment_screen_unassign;

  /// No description provided for @assignment_screen_pipe_logs.
  ///
  /// In en, this message translates to:
  /// **'Pipe logs'**
  String get assignment_screen_pipe_logs;

  /// No description provided for @assignment_screen_pipe_logs_placeholder.
  ///
  /// In en, this message translates to:
  /// **'No logs so far...'**
  String get assignment_screen_pipe_logs_placeholder;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pl': return AppLocalizationsPl();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
