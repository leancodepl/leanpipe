import 'app_localizations.dart';

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get common_app_name => 'LeanCode template';

  @override
  String get force_update_screen_title => 'Aktualizuj aplikację';

  @override
  String get force_update_screen_subtitle =>
      'Dostępna jest nowa wersja aplikacji, pobierz ją aby korzystać';

  @override
  String get force_update_screen_updateButton => 'Aktualizuj';

  @override
  String get suggest_update_dialog_title => 'Aktualizuj aplikację';

  @override
  String get suggest_update_dialog_subtitle =>
      'Dostępna jest nowa wersja aplikacji, możesz ją teraz pobrać';

  @override
  String get suggest_update_dialog_updateButton => 'Aktualizuj';

  @override
  String get suggest_update_dialog_cancelButton => 'Anuluj';

  @override
  String get validator_field_empty => 'Pole nie może być puste';

  @override
  String get validator_email_wrong_format => 'Niepoprawny format email';

  @override
  String get validator_passwords_not_match => 'Hasła nie są identyczne';

  @override
  String get validator_min_chars_password => 'Hasło musi mieć minimum 8 znaków';

  @override
  String get enter_code_email => 'Podaj kod z e-maila';

  @override
  String get error_verification => 'Błąd podczas weryfikacji';

  @override
  String get success_verification => 'Zweryfikowane';

  @override
  String get verification_page_title => 'Weryfikacja konta';

  @override
  String get login_page_recovery_button => 'Zapomniane hasło';

  @override
  String get recovery_page_title => 'Odzyskiwanie konta';

  @override
  String get recovery_page_password_changed => 'Hasło zostało zmienione';

  @override
  String get recovery_page_send => 'Wyślij';

  @override
  String get recovery_page_pin_title => 'PIN';

  @override
  String get register => 'Zarejestruj';

  @override
  String get continue_registration => 'Kontynuuj';

  @override
  String get terms_conditions_checkbox => 'Zgadzam się z warunkami';

  @override
  String get login_button => 'Login';

  @override
  String get email_field => 'E-mail';

  @override
  String get password_field => 'Hasło';

  @override
  String get register_first_name_field => 'Imię';

  @override
  String get register_family_name_field => 'Nazwisko';

  @override
  String get register_header => 'Rejestracja';

  @override
  String get login_header => 'Logowanie';

  @override
  String field_error(Object errorId) {
    return 'Pole zawiera błąd: $errorId';
  }

  @override
  String get kratos_info_self_service_login_root => '';

  @override
  String get kratos_info_self_service_login => 'Zaloguj się';

  @override
  String get kratos_info_self_service_login_with => 'Zaloguj z ';

  @override
  String get kratos_info_self_service_login_re_auth =>
      'Prosimy, potwierdź tę akcję weryfikując swoją tożsamość';

  @override
  String get kratos_info_self_service_login_mfa =>
      'Wypełnij kolejny krok logowania';

  @override
  String get kratos_info_self_service_login_verify => 'Zweryfikuj';

  @override
  String get kratos_info_self_service_login_totp_label =>
      'Kod uwierzytelnienia';

  @override
  String get kratos_info_login_lookup_label => 'Kod przywracania';

  @override
  String get kratos_info_self_service_login_web_authn =>
      'Wprowadź kod bezpieczeństwa';

  @override
  String get kratos_info_login_totp => 'Potwierdź i zaloguj się';

  @override
  String get kratos_info_login_lookup => 'Wprowadź kod przywracania';

  @override
  String get kratos_info_self_service_login_continue_web_authn =>
      'Kontynuuj z kodem bezpieczeństwa';

  @override
  String get kratos_info_self_service_login_web_authn_passwordless =>
      'Przygotuj swoje urządzenie (np. klucz bezpieczeństwa, skaner biometryczny) i kliknij przycisk Kontynuuj';

  @override
  String get kratos_info_self_service_login_continue => 'Kontynuuj';

  @override
  String get kratos_info_self_service_logout => '';

  @override
  String get kratos_info_self_service_mfa => '';

  @override
  String get kratos_info_self_service_registration_root => '';

  @override
  String get kratos_info_self_service_registration => 'Zarejestruj się';

  @override
  String get kratos_info_self_service_registration_with => 'Zarejestruj z ';

  @override
  String get kratos_info_self_service_registration_continue => 'Kontynuuj';

  @override
  String get kratos_info_self_service_registration_register_web_authn =>
      'Zarejestruj się z kluczem bezpieczeństwa';

  @override
  String get kratos_info_self_service_settings => '';

  @override
  String get kratos_info_self_service_settings_update_success =>
      'Zmiany zostały zapisane';

  @override
  String get kratos_info_self_service_settings_update_link_oidc =>
      'Połącz konto ';

  @override
  String get kratos_info_self_service_settings_update_unlink_oidc =>
      'Odłącz konto ';

  @override
  String get kratos_info_self_service_settings_update_unlink_totp =>
      'Wyłącz weryfikację dwuetapową';

  @override
  String get kratos_info_self_service_settings_totp_qrcode => '';

  @override
  String get kratos_info_self_service_settings_totp_secret => '';

  @override
  String get kratos_info_self_service_settings_reveal_lookup => '';

  @override
  String get kratos_info_self_service_settings_regenerate_lookup => '';

  @override
  String get kratos_info_self_service_settings_lookup_secret => '';

  @override
  String get kratos_info_self_service_settings_lookup_secret_label => '';

  @override
  String get kratos_info_self_service_settings_lookup_confirm => '';

  @override
  String get kratos_info_self_service_settings_register_web_authn => '';

  @override
  String
      get kratos_info_self_service_settings_register_web_authn_display_name =>
          '';

  @override
  String get kratos_info_self_service_settings_lookup_secret_used => '';

  @override
  String get kratos_info_self_service_settings_lookup_secret_list => '';

  @override
  String get kratos_info_self_service_settings_disable_lookup => '';

  @override
  String get kratos_info_self_service_settings_totp_secret_label =>
      'Jeśli nie możesz użyć kodu QR, podaj w aplikacji ten klucz aktywacyjny:';

  @override
  String get kratos_info_self_service_settings_remove_web_authn => '';

  @override
  String get kratos_info_self_service_recovery => '';

  @override
  String get kratos_info_self_service_recovery_successful =>
      'Udało Ci się odzyskać dostęp do konta. Zmień swoje hasło w poniższym formularzu.';

  @override
  String get kratos_info_self_service_recovery_email_sent =>
      'Na podany adres e-mail wysłaliśmy Ci wiadomość z linkiem do resetowania hasła.';

  @override
  String get kratos_info_self_service_recovery_email_with_code_sent =>
      'Na podany przez Ciebie adres email wysłaliśmy wiadomość zawierającą kod do odzyskiwania konta.';

  @override
  String get kratos_info_node_label => '';

  @override
  String get kratos_info_node_label_input_password => 'Hasło';

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
  String get kratos_info_node_label_email => '';

  @override
  String get kratos_info_node_label_resend_otp => '';

  @override
  String get kratos_info_node_label_continue => '';

  @override
  String get kratos_info_node_label_recovery_code => '';

  @override
  String get kratos_info_node_label_verification_code => '';

  @override
  String get kratos_info_self_service_verification => '';

  @override
  String get kratos_info_self_service_verification_email_sent =>
      'Wiadomość e-mail z linkiem weryfikacyjnym została wysłana na podany przez Ciebie adres';

  @override
  String get kratos_info_self_service_verification_successful =>
      'Twój adres e-mail został potwierdzony';

  @override
  String get kratos_info_self_service_verification_email_with_code_sent =>
      'Wiadomość e-mail z kodem weryfikacyjnym została wysłana na podany przez Ciebie adres';

  @override
  String get kratos_error_validation => '';

  @override
  String get kratos_error_validation_generic => 'Pole ma niepoprawny format';

  @override
  String get kratos_error_validation_required => 'To pole jest wymagane';

  @override
  String get kratos_error_validation_min_length =>
      'Wymagane jest minimum  znaków';

  @override
  String get kratos_error_validation_invalid_format =>
      'Niepoprawny format danych';

  @override
  String get kratos_error_validation_password_policy_violation =>
      'Min. 8 characters, Password must not be on the list of leaked passwords';

  @override
  String get kratos_error_validation_invalid_credentials =>
      'Nieprawidłowy adres e-mail lub hasło';

  @override
  String get kratos_error_validation_duplicate_credentials =>
      'Konto z takimi danymi logowania już istnieje';

  @override
  String get kratos_error_validation_totp_verifier_wrong =>
      'Podany kod weryfikacyjny jest nieprawidłowy';

  @override
  String get kratos_error_validation_identifier_missing => '';

  @override
  String get kratos_error_validation_address_not_verified => '';

  @override
  String get kratos_error_validation_no_totp_device => '';

  @override
  String get kratos_error_validation_lookup_already_used =>
      'Kod przywracania został już wykorzystany';

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
  String get kratos_error_validation_recovery_retry_success =>
      'Zapytanie zostało już wysłane poprawnie i nie może zostać powtórzone';

  @override
  String get kratos_error_validation_recovery_state_failure => '';

  @override
  String get kratos_error_validation_recovery_missing_recovery_token => '';

  @override
  String get kratos_error_validation_recovery_token_invalid_or_already_used =>
      'Kod jest nieprawidłowy lub został już wykorzystany';

  @override
  String get kratos_error_validation_recovery_flow_expired => '';

  @override
  String get kratos_error_validation_recovery_code_invalid_or_already_used =>
      'Kod jest niepoprawny lub został już wykorzystany';

  @override
  String get kratos_error_validation_verification => '';

  @override
  String
      get kratos_error_validation_verification_token_invalid_or_already_used =>
          'Kod jest nieprawidłowy lub został już wykorzystany';

  @override
  String get kratos_error_validation_verification_retry_success => '';

  @override
  String get kratos_error_validation_verification_state_failure => '';

  @override
  String get kratos_error_validation_verification_missing_verification_token =>
      '';

  @override
  String get kratos_error_validation_verification_flow_expired => '';

  @override
  String
      get kratos_error_validation_verification_code_invalid_or_already_used =>
          'Podany kod jest niepoprawny lub został już użyty. Spróbuj ponownie';

  @override
  String get kratos_error_system => 'Błąd systemu';

  @override
  String get kratos_error_system_generic => 'Wystąpił błąd';

  @override
  String get register_with_apple_button => 'Zarejestruj z Apple';

  @override
  String get register_with_google_button => 'Zarejestruj z Google';

  @override
  String get register_with_facebook_button => 'Zarejestruj z Facebook';

  @override
  String get error_handling_network =>
      'Brak internetu, spróbuj ponownie później';

  @override
  String get error_handling_authorization => 'Brak dostępu, cofnij';

  @override
  String get error_handling_unknown => 'Coś poszło nie tak, spróbuj ponownie';

  @override
  String get register_unknown_error => 'Coś poszło nie tak, spróbuj ponownie';

  @override
  String get login_unknown_error => 'Coś poszło nie tak, spróbuj ponownie';

  @override
  String get social_traits_unknown_error =>
      'Coś poszło nie tak, spróbuj ponownie';

  @override
  String get login_with_apple_button => 'Zaloguj z Apple';

  @override
  String get login_with_google_button => 'Zaloguj z Google';

  @override
  String get login_with_facebook_button => 'Zaloguj z Facebook';

  @override
  String get social_traits_cancel => 'Anuluj';

  @override
  String get change_password_title => 'Zmień hasło';

  @override
  String get change_password_confirm_password => 'Potwierdź hasło';

  @override
  String get profile_my_profile => 'Mój profil';

  @override
  String get profile_password_change => 'Zmiana hasła';

  @override
  String get profile_logout => 'Wyloguj';

  @override
  String get profile_edit_form => 'Edytuj';

  @override
  String get profile_save_changes => 'Zapisz';

  @override
  String get reauthorize_title => 'Autoryzacja';

  @override
  String get reauthorize_info =>
      'Aby wykonać tę operację musisz się ponownie zalogować.';

  @override
  String get reauthorize_info_button => 'Dalej';
}
