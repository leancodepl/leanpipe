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
/// import 'l10n/app_localizations.dart';
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
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
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
  /// In pl, this message translates to:
  /// **'LeanCode template'**
  String get common_app_name;

  /// No description provided for @force_update_screen_title.
  ///
  /// In pl, this message translates to:
  /// **'Aktualizuj aplikację'**
  String get force_update_screen_title;

  /// No description provided for @force_update_screen_subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Dostępna jest nowa wersja aplikacji, pobierz ją aby korzystać'**
  String get force_update_screen_subtitle;

  /// No description provided for @force_update_screen_updateButton.
  ///
  /// In pl, this message translates to:
  /// **'Aktualizuj'**
  String get force_update_screen_updateButton;

  /// No description provided for @suggest_update_dialog_title.
  ///
  /// In pl, this message translates to:
  /// **'Aktualizuj aplikację'**
  String get suggest_update_dialog_title;

  /// No description provided for @suggest_update_dialog_subtitle.
  ///
  /// In pl, this message translates to:
  /// **'Dostępna jest nowa wersja aplikacji, możesz ją teraz pobrać'**
  String get suggest_update_dialog_subtitle;

  /// No description provided for @suggest_update_dialog_updateButton.
  ///
  /// In pl, this message translates to:
  /// **'Aktualizuj'**
  String get suggest_update_dialog_updateButton;

  /// No description provided for @suggest_update_dialog_cancelButton.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get suggest_update_dialog_cancelButton;

  /// No description provided for @validator_field_empty.
  ///
  /// In pl, this message translates to:
  /// **'Pole nie może być puste'**
  String get validator_field_empty;

  /// No description provided for @validator_email_wrong_format.
  ///
  /// In pl, this message translates to:
  /// **'Niepoprawny format email'**
  String get validator_email_wrong_format;

  /// No description provided for @validator_passwords_not_match.
  ///
  /// In pl, this message translates to:
  /// **'Hasła nie są identyczne'**
  String get validator_passwords_not_match;

  /// No description provided for @validator_min_chars_password.
  ///
  /// In pl, this message translates to:
  /// **'Hasło musi mieć minimum 8 znaków'**
  String get validator_min_chars_password;

  /// No description provided for @enter_code_email.
  ///
  /// In pl, this message translates to:
  /// **'Podaj kod z e-maila'**
  String get enter_code_email;

  /// No description provided for @error_verification.
  ///
  /// In pl, this message translates to:
  /// **'Błąd podczas weryfikacji'**
  String get error_verification;

  /// No description provided for @success_verification.
  ///
  /// In pl, this message translates to:
  /// **'Zweryfikowane'**
  String get success_verification;

  /// No description provided for @verification_page_title.
  ///
  /// In pl, this message translates to:
  /// **'Weryfikacja konta'**
  String get verification_page_title;

  /// No description provided for @login_page_recovery_button.
  ///
  /// In pl, this message translates to:
  /// **'Zapomniane hasło'**
  String get login_page_recovery_button;

  /// No description provided for @recovery_page_title.
  ///
  /// In pl, this message translates to:
  /// **'Odzyskiwanie konta'**
  String get recovery_page_title;

  /// No description provided for @recovery_page_password_changed.
  ///
  /// In pl, this message translates to:
  /// **'Hasło zostało zmienione'**
  String get recovery_page_password_changed;

  /// No description provided for @recovery_page_send.
  ///
  /// In pl, this message translates to:
  /// **'Wyślij'**
  String get recovery_page_send;

  /// No description provided for @recovery_page_pin_title.
  ///
  /// In pl, this message translates to:
  /// **'PIN'**
  String get recovery_page_pin_title;

  /// No description provided for @register.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj'**
  String get register;

  /// No description provided for @continue_registration.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj'**
  String get continue_registration;

  /// No description provided for @terms_conditions_checkbox.
  ///
  /// In pl, this message translates to:
  /// **'Zgadzam się z warunkami'**
  String get terms_conditions_checkbox;

  /// No description provided for @login_button.
  ///
  /// In pl, this message translates to:
  /// **'Login'**
  String get login_button;

  /// No description provided for @email_field.
  ///
  /// In pl, this message translates to:
  /// **'E-mail'**
  String get email_field;

  /// No description provided for @password_field.
  ///
  /// In pl, this message translates to:
  /// **'Hasło'**
  String get password_field;

  /// No description provided for @register_first_name_field.
  ///
  /// In pl, this message translates to:
  /// **'Imię'**
  String get register_first_name_field;

  /// No description provided for @register_family_name_field.
  ///
  /// In pl, this message translates to:
  /// **'Nazwisko'**
  String get register_family_name_field;

  /// No description provided for @register_header.
  ///
  /// In pl, this message translates to:
  /// **'Rejestracja'**
  String get register_header;

  /// No description provided for @login_header.
  ///
  /// In pl, this message translates to:
  /// **'Logowanie'**
  String get login_header;

  /// No description provided for @field_error.
  ///
  /// In pl, this message translates to:
  /// **'Pole zawiera błąd: {errorId}'**
  String field_error(Object errorId);

  /// No description provided for @kratos_info_self_service_login_root.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_login_root;

  /// No description provided for @kratos_info_self_service_login.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj się'**
  String get kratos_info_self_service_login;

  /// No description provided for @kratos_info_self_service_login_with.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj z '**
  String get kratos_info_self_service_login_with;

  /// No description provided for @kratos_info_self_service_login_re_auth.
  ///
  /// In pl, this message translates to:
  /// **'Prosimy, potwierdź tę akcję weryfikując swoją tożsamość'**
  String get kratos_info_self_service_login_re_auth;

  /// No description provided for @kratos_info_self_service_login_mfa.
  ///
  /// In pl, this message translates to:
  /// **'Wypełnij kolejny krok logowania'**
  String get kratos_info_self_service_login_mfa;

  /// No description provided for @kratos_info_self_service_login_verify.
  ///
  /// In pl, this message translates to:
  /// **'Zweryfikuj'**
  String get kratos_info_self_service_login_verify;

  /// No description provided for @kratos_info_self_service_login_totp_label.
  ///
  /// In pl, this message translates to:
  /// **'Kod uwierzytelnienia'**
  String get kratos_info_self_service_login_totp_label;

  /// No description provided for @kratos_info_login_lookup_label.
  ///
  /// In pl, this message translates to:
  /// **'Kod przywracania'**
  String get kratos_info_login_lookup_label;

  /// No description provided for @kratos_info_self_service_login_web_authn.
  ///
  /// In pl, this message translates to:
  /// **'Wprowadź kod bezpieczeństwa'**
  String get kratos_info_self_service_login_web_authn;

  /// No description provided for @kratos_info_login_totp.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź i zaloguj się'**
  String get kratos_info_login_totp;

  /// No description provided for @kratos_info_login_lookup.
  ///
  /// In pl, this message translates to:
  /// **'Wprowadź kod przywracania'**
  String get kratos_info_login_lookup;

  /// No description provided for @kratos_info_self_service_login_continue_web_authn.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj z kodem bezpieczeństwa'**
  String get kratos_info_self_service_login_continue_web_authn;

  /// No description provided for @kratos_info_self_service_login_web_authn_passwordless.
  ///
  /// In pl, this message translates to:
  /// **'Przygotuj swoje urządzenie (np. klucz bezpieczeństwa, skaner biometryczny) i kliknij przycisk Kontynuuj'**
  String get kratos_info_self_service_login_web_authn_passwordless;

  /// No description provided for @kratos_info_self_service_login_continue.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj'**
  String get kratos_info_self_service_login_continue;

  /// No description provided for @kratos_info_self_service_logout.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_logout;

  /// No description provided for @kratos_info_self_service_mfa.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_mfa;

  /// No description provided for @kratos_info_self_service_registration_root.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_registration_root;

  /// No description provided for @kratos_info_self_service_registration.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj się'**
  String get kratos_info_self_service_registration;

  /// No description provided for @kratos_info_self_service_registration_with.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj z '**
  String get kratos_info_self_service_registration_with;

  /// No description provided for @kratos_info_self_service_registration_continue.
  ///
  /// In pl, this message translates to:
  /// **'Kontynuuj'**
  String get kratos_info_self_service_registration_continue;

  /// No description provided for @kratos_info_self_service_registration_register_web_authn.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj się z kluczem bezpieczeństwa'**
  String get kratos_info_self_service_registration_register_web_authn;

  /// No description provided for @kratos_info_self_service_settings.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings;

  /// No description provided for @kratos_info_self_service_settings_update_success.
  ///
  /// In pl, this message translates to:
  /// **'Zmiany zostały zapisane'**
  String get kratos_info_self_service_settings_update_success;

  /// No description provided for @kratos_info_self_service_settings_update_link_oidc.
  ///
  /// In pl, this message translates to:
  /// **'Połącz konto '**
  String get kratos_info_self_service_settings_update_link_oidc;

  /// No description provided for @kratos_info_self_service_settings_update_unlink_oidc.
  ///
  /// In pl, this message translates to:
  /// **'Odłącz konto '**
  String get kratos_info_self_service_settings_update_unlink_oidc;

  /// No description provided for @kratos_info_self_service_settings_update_unlink_totp.
  ///
  /// In pl, this message translates to:
  /// **'Wyłącz weryfikację dwuetapową'**
  String get kratos_info_self_service_settings_update_unlink_totp;

  /// No description provided for @kratos_info_self_service_settings_totp_qrcode.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_totp_qrcode;

  /// No description provided for @kratos_info_self_service_settings_totp_secret.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_totp_secret;

  /// No description provided for @kratos_info_self_service_settings_reveal_lookup.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_reveal_lookup;

  /// No description provided for @kratos_info_self_service_settings_regenerate_lookup.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_regenerate_lookup;

  /// No description provided for @kratos_info_self_service_settings_lookup_secret.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_lookup_secret;

  /// No description provided for @kratos_info_self_service_settings_lookup_secret_label.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_lookup_secret_label;

  /// No description provided for @kratos_info_self_service_settings_lookup_confirm.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_lookup_confirm;

  /// No description provided for @kratos_info_self_service_settings_register_web_authn.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_register_web_authn;

  /// No description provided for @kratos_info_self_service_settings_register_web_authn_display_name.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_register_web_authn_display_name;

  /// No description provided for @kratos_info_self_service_settings_lookup_secret_used.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_lookup_secret_used;

  /// No description provided for @kratos_info_self_service_settings_lookup_secret_list.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_lookup_secret_list;

  /// No description provided for @kratos_info_self_service_settings_disable_lookup.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_disable_lookup;

  /// No description provided for @kratos_info_self_service_settings_totp_secret_label.
  ///
  /// In pl, this message translates to:
  /// **'Jeśli nie możesz użyć kodu QR, podaj w aplikacji ten klucz aktywacyjny:'**
  String get kratos_info_self_service_settings_totp_secret_label;

  /// No description provided for @kratos_info_self_service_settings_remove_web_authn.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_settings_remove_web_authn;

  /// No description provided for @kratos_info_self_service_recovery.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_recovery;

  /// No description provided for @kratos_info_self_service_recovery_successful.
  ///
  /// In pl, this message translates to:
  /// **'Udało Ci się odzyskać dostęp do konta. Zmień swoje hasło w poniższym formularzu.'**
  String get kratos_info_self_service_recovery_successful;

  /// No description provided for @kratos_info_self_service_recovery_email_sent.
  ///
  /// In pl, this message translates to:
  /// **'Na podany adres e-mail wysłaliśmy Ci wiadomość z linkiem do resetowania hasła.'**
  String get kratos_info_self_service_recovery_email_sent;

  /// No description provided for @kratos_info_self_service_recovery_email_with_code_sent.
  ///
  /// In pl, this message translates to:
  /// **'Na podany przez Ciebie adres email wysłaliśmy wiadomość zawierającą kod do odzyskiwania konta.'**
  String get kratos_info_self_service_recovery_email_with_code_sent;

  /// No description provided for @kratos_info_node_label.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label;

  /// No description provided for @kratos_info_node_label_input_password.
  ///
  /// In pl, this message translates to:
  /// **'Hasło'**
  String get kratos_info_node_label_input_password;

  /// No description provided for @kratos_info_node_label_generated.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_generated;

  /// No description provided for @kratos_info_node_label_save.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_save;

  /// No description provided for @kratos_info_node_label_id.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_id;

  /// No description provided for @kratos_info_node_label_submit.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_submit;

  /// No description provided for @kratos_info_node_label_verify_otp.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_verify_otp;

  /// No description provided for @kratos_info_node_label_email.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_email;

  /// No description provided for @kratos_info_node_label_resend_otp.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_resend_otp;

  /// No description provided for @kratos_info_node_label_continue.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_continue;

  /// No description provided for @kratos_info_node_label_recovery_code.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_recovery_code;

  /// No description provided for @kratos_info_node_label_verification_code.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_node_label_verification_code;

  /// No description provided for @kratos_info_self_service_verification.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_info_self_service_verification;

  /// No description provided for @kratos_info_self_service_verification_email_sent.
  ///
  /// In pl, this message translates to:
  /// **'Wiadomość e-mail z linkiem weryfikacyjnym została wysłana na podany przez Ciebie adres'**
  String get kratos_info_self_service_verification_email_sent;

  /// No description provided for @kratos_info_self_service_verification_successful.
  ///
  /// In pl, this message translates to:
  /// **'Twój adres e-mail został potwierdzony'**
  String get kratos_info_self_service_verification_successful;

  /// No description provided for @kratos_info_self_service_verification_email_with_code_sent.
  ///
  /// In pl, this message translates to:
  /// **'Wiadomość e-mail z kodem weryfikacyjnym została wysłana na podany przez Ciebie adres'**
  String get kratos_info_self_service_verification_email_with_code_sent;

  /// No description provided for @kratos_error_validation.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation;

  /// No description provided for @kratos_error_validation_generic.
  ///
  /// In pl, this message translates to:
  /// **'Pole ma niepoprawny format'**
  String get kratos_error_validation_generic;

  /// No description provided for @kratos_error_validation_required.
  ///
  /// In pl, this message translates to:
  /// **'To pole jest wymagane'**
  String get kratos_error_validation_required;

  /// No description provided for @kratos_error_validation_min_length.
  ///
  /// In pl, this message translates to:
  /// **'Wymagane jest minimum  znaków'**
  String get kratos_error_validation_min_length;

  /// No description provided for @kratos_error_validation_invalid_format.
  ///
  /// In pl, this message translates to:
  /// **'Niepoprawny format danych'**
  String get kratos_error_validation_invalid_format;

  /// No description provided for @kratos_error_validation_password_policy_violation.
  ///
  /// In pl, this message translates to:
  /// **'Min. 8 characters, Password must not be on the list of leaked passwords'**
  String get kratos_error_validation_password_policy_violation;

  /// No description provided for @kratos_error_validation_invalid_credentials.
  ///
  /// In pl, this message translates to:
  /// **'Nieprawidłowy adres e-mail lub hasło'**
  String get kratos_error_validation_invalid_credentials;

  /// No description provided for @kratos_error_validation_duplicate_credentials.
  ///
  /// In pl, this message translates to:
  /// **'Konto z takimi danymi logowania już istnieje'**
  String get kratos_error_validation_duplicate_credentials;

  /// No description provided for @kratos_error_validation_totp_verifier_wrong.
  ///
  /// In pl, this message translates to:
  /// **'Podany kod weryfikacyjny jest nieprawidłowy'**
  String get kratos_error_validation_totp_verifier_wrong;

  /// No description provided for @kratos_error_validation_identifier_missing.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_identifier_missing;

  /// No description provided for @kratos_error_validation_address_not_verified.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_address_not_verified;

  /// No description provided for @kratos_error_validation_no_totp_device.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_no_totp_device;

  /// No description provided for @kratos_error_validation_lookup_already_used.
  ///
  /// In pl, this message translates to:
  /// **'Kod przywracania został już wykorzystany'**
  String get kratos_error_validation_lookup_already_used;

  /// No description provided for @kratos_error_validation_no_web_authn_device.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_no_web_authn_device;

  /// No description provided for @kratos_error_validation_no_lookup.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_no_lookup;

  /// No description provided for @kratos_error_validation_such_no_web_authn_user.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_such_no_web_authn_user;

  /// No description provided for @kratos_error_validation_lookup_invalid.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_lookup_invalid;

  /// No description provided for @kratos_error_validation_max_length.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_max_length;

  /// No description provided for @kratos_error_validation_minimum.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_minimum;

  /// No description provided for @kratos_error_validation_exclusive_minimum.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_exclusive_minimum;

  /// No description provided for @kratos_error_validation_maximum.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_maximum;

  /// No description provided for @kratos_error_validation_exclusive_maximum.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_exclusive_maximum;

  /// No description provided for @kratos_error_validation_multiple_of.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_multiple_of;

  /// No description provided for @kratos_error_validation_max_items.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_max_items;

  /// No description provided for @kratos_error_validation_min_items.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_min_items;

  /// No description provided for @kratos_error_validation_unique_items.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_unique_items;

  /// No description provided for @kratos_error_validation_wrong_type.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_wrong_type;

  /// No description provided for @kratos_error_validation_duplicate_credentials_on_oidc_link.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_duplicate_credentials_on_oidc_link;

  /// No description provided for @kratos_error_validation_login.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_login;

  /// No description provided for @kratos_error_validation_login_flow_expired.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_login_flow_expired;

  /// No description provided for @kratos_error_validation_login_no_strategy_found.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_login_no_strategy_found;

  /// No description provided for @kratos_error_validation_registration_no_strategy_found.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_registration_no_strategy_found;

  /// No description provided for @kratos_error_validation_settings_no_strategy_found.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_settings_no_strategy_found;

  /// No description provided for @kratos_error_validation_recovery_no_strategy_found.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery_no_strategy_found;

  /// No description provided for @kratos_error_validation_verification_no_strategy_found.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_no_strategy_found;

  /// No description provided for @kratos_error_validation_registration.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_registration;

  /// No description provided for @kratos_error_validation_registration_flow_expired.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_registration_flow_expired;

  /// No description provided for @kratos_error_validation_settings.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_settings;

  /// No description provided for @kratos_error_validation_settings_flow_expired.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_settings_flow_expired;

  /// No description provided for @kratos_error_validation_recovery.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery;

  /// No description provided for @kratos_error_validation_recovery_retry_success.
  ///
  /// In pl, this message translates to:
  /// **'Zapytanie zostało już wysłane poprawnie i nie może zostać powtórzone'**
  String get kratos_error_validation_recovery_retry_success;

  /// No description provided for @kratos_error_validation_recovery_state_failure.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery_state_failure;

  /// No description provided for @kratos_error_validation_recovery_missing_recovery_token.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery_missing_recovery_token;

  /// No description provided for @kratos_error_validation_recovery_token_invalid_or_already_used.
  ///
  /// In pl, this message translates to:
  /// **'Kod jest nieprawidłowy lub został już wykorzystany'**
  String get kratos_error_validation_recovery_token_invalid_or_already_used;

  /// No description provided for @kratos_error_validation_recovery_flow_expired.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_recovery_flow_expired;

  /// No description provided for @kratos_error_validation_recovery_code_invalid_or_already_used.
  ///
  /// In pl, this message translates to:
  /// **'Kod jest niepoprawny lub został już wykorzystany'**
  String get kratos_error_validation_recovery_code_invalid_or_already_used;

  /// No description provided for @kratos_error_validation_verification.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_verification;

  /// No description provided for @kratos_error_validation_verification_token_invalid_or_already_used.
  ///
  /// In pl, this message translates to:
  /// **'Kod jest nieprawidłowy lub został już wykorzystany'**
  String get kratos_error_validation_verification_token_invalid_or_already_used;

  /// No description provided for @kratos_error_validation_verification_retry_success.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_retry_success;

  /// No description provided for @kratos_error_validation_verification_state_failure.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_state_failure;

  /// No description provided for @kratos_error_validation_verification_missing_verification_token.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_missing_verification_token;

  /// No description provided for @kratos_error_validation_verification_flow_expired.
  ///
  /// In pl, this message translates to:
  /// **''**
  String get kratos_error_validation_verification_flow_expired;

  /// No description provided for @kratos_error_validation_verification_code_invalid_or_already_used.
  ///
  /// In pl, this message translates to:
  /// **'Podany kod jest niepoprawny lub został już użyty. Spróbuj ponownie'**
  String get kratos_error_validation_verification_code_invalid_or_already_used;

  /// No description provided for @kratos_error_system.
  ///
  /// In pl, this message translates to:
  /// **'Błąd systemu'**
  String get kratos_error_system;

  /// No description provided for @kratos_error_system_generic.
  ///
  /// In pl, this message translates to:
  /// **'Wystąpił błąd'**
  String get kratos_error_system_generic;

  /// No description provided for @register_with_apple_button.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj z Apple'**
  String get register_with_apple_button;

  /// No description provided for @register_with_google_button.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj z Google'**
  String get register_with_google_button;

  /// No description provided for @register_with_facebook_button.
  ///
  /// In pl, this message translates to:
  /// **'Zarejestruj z Facebook'**
  String get register_with_facebook_button;

  /// No description provided for @error_handling_network.
  ///
  /// In pl, this message translates to:
  /// **'Brak internetu, spróbuj ponownie później'**
  String get error_handling_network;

  /// No description provided for @error_handling_authorization.
  ///
  /// In pl, this message translates to:
  /// **'Brak dostępu, cofnij'**
  String get error_handling_authorization;

  /// No description provided for @error_handling_unknown.
  ///
  /// In pl, this message translates to:
  /// **'Coś poszło nie tak, spróbuj ponownie'**
  String get error_handling_unknown;

  /// No description provided for @register_unknown_error.
  ///
  /// In pl, this message translates to:
  /// **'Coś poszło nie tak, spróbuj ponownie'**
  String get register_unknown_error;

  /// No description provided for @login_unknown_error.
  ///
  /// In pl, this message translates to:
  /// **'Coś poszło nie tak, spróbuj ponownie'**
  String get login_unknown_error;

  /// No description provided for @social_traits_unknown_error.
  ///
  /// In pl, this message translates to:
  /// **'Coś poszło nie tak, spróbuj ponownie'**
  String get social_traits_unknown_error;

  /// No description provided for @login_with_apple_button.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj z Apple'**
  String get login_with_apple_button;

  /// No description provided for @login_with_google_button.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj z Google'**
  String get login_with_google_button;

  /// No description provided for @login_with_facebook_button.
  ///
  /// In pl, this message translates to:
  /// **'Zaloguj z Facebook'**
  String get login_with_facebook_button;

  /// No description provided for @social_traits_cancel.
  ///
  /// In pl, this message translates to:
  /// **'Anuluj'**
  String get social_traits_cancel;

  /// No description provided for @change_password_title.
  ///
  /// In pl, this message translates to:
  /// **'Zmień hasło'**
  String get change_password_title;

  /// No description provided for @change_password_confirm_password.
  ///
  /// In pl, this message translates to:
  /// **'Potwierdź hasło'**
  String get change_password_confirm_password;

  /// No description provided for @profile_my_profile.
  ///
  /// In pl, this message translates to:
  /// **'Mój profil'**
  String get profile_my_profile;

  /// No description provided for @profile_password_change.
  ///
  /// In pl, this message translates to:
  /// **'Zmiana hasła'**
  String get profile_password_change;

  /// No description provided for @profile_logout.
  ///
  /// In pl, this message translates to:
  /// **'Wyloguj'**
  String get profile_logout;

  /// No description provided for @profile_edit_form.
  ///
  /// In pl, this message translates to:
  /// **'Edytuj'**
  String get profile_edit_form;

  /// No description provided for @profile_save_changes.
  ///
  /// In pl, this message translates to:
  /// **'Zapisz'**
  String get profile_save_changes;

  /// No description provided for @reauthorize_title.
  ///
  /// In pl, this message translates to:
  /// **'Autoryzacja'**
  String get reauthorize_title;

  /// No description provided for @reauthorize_info.
  ///
  /// In pl, this message translates to:
  /// **'Aby wykonać tę operację musisz się ponownie zalogować.'**
  String get reauthorize_info;

  /// No description provided for @reauthorize_info_button.
  ///
  /// In pl, this message translates to:
  /// **'Dalej'**
  String get reauthorize_info_button;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'pl'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'pl':
      return AppLocalizationsPl();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
