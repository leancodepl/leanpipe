import 'package:app/resources/strings.dart';
import 'package:flutter/material.dart';
import 'package:leancode_kratos_client/leancode_kratos_client.dart';

extension KratosErrorExtension on KratosError {
  String localized(BuildContext context) {
    final s = l10n(context);

    return switch (this) {
      KratosError.infoSelfServiceLoginRoot =>
        s.kratos_info_self_service_login_root,
      KratosError.infoSelfServiceLogin => s.kratos_info_self_service_login,
      KratosError.infoSelfServiceLoginWith =>
        s.kratos_info_self_service_login_with,
      KratosError.infoSelfServiceLoginReAuth =>
        s.kratos_info_self_service_login_re_auth,
      KratosError.infoSelfServiceLoginMFA =>
        s.kratos_info_self_service_login_mfa,
      KratosError.infoSelfServiceLoginVerify =>
        s.kratos_info_self_service_login_verify,
      KratosError.infoSelfServiceLoginTOTPLabel =>
        s.kratos_info_self_service_login_totp_label,
      KratosError.infoLoginLookupLabel => s.kratos_info_login_lookup_label,
      KratosError.infoSelfServiceLoginWebAuthn =>
        s.kratos_info_self_service_login_web_authn,
      KratosError.infoLoginTOTP => s.kratos_info_login_totp,
      KratosError.infoLoginLookup => s.kratos_info_login_lookup,
      KratosError.infoSelfServiceLoginContinueWebAuthn =>
        s.kratos_info_self_service_login_continue_web_authn,
      KratosError.infoSelfServiceLoginWebAuthnPasswordless =>
        s.kratos_info_self_service_login_web_authn_passwordless,
      KratosError.infoSelfServiceLoginContinue =>
        s.kratos_info_self_service_login_continue,
      KratosError.infoSelfServiceLogout => s.kratos_info_self_service_logout,
      KratosError.infoSelfServiceMFA => s.kratos_info_self_service_mfa,
      KratosError.infoSelfServiceRegistrationRoot =>
        s.kratos_info_self_service_registration_root,
      KratosError.infoSelfServiceRegistration =>
        s.kratos_info_self_service_registration,
      KratosError.infoSelfServiceRegistrationWith =>
        s.kratos_info_self_service_registration_with,
      KratosError.infoSelfServiceRegistrationContinue =>
        s.kratos_info_self_service_registration_continue,
      KratosError.infoSelfServiceRegistrationRegisterWebAuthn =>
        s.kratos_info_self_service_registration_register_web_authn,
      KratosError.infoSelfServiceSettings =>
        s.kratos_info_self_service_settings,
      KratosError.infoSelfServiceSettingsUpdateSuccess =>
        s.kratos_info_self_service_settings_update_success,
      KratosError.infoSelfServiceSettingsUpdateLinkOidc =>
        s.kratos_info_self_service_settings_update_link_oidc,
      KratosError.infoSelfServiceSettingsUpdateUnlinkOidc =>
        s.kratos_info_self_service_settings_update_unlink_oidc,
      KratosError.infoSelfServiceSettingsUpdateUnlinkTOTP =>
        s.kratos_info_self_service_settings_update_unlink_totp,
      KratosError.infoSelfServiceSettingsTOTPQRCode =>
        s.kratos_info_self_service_settings_totp_qrcode,
      KratosError.infoSelfServiceSettingsTOTPSecret =>
        s.kratos_info_self_service_settings_totp_secret,
      KratosError.infoSelfServiceSettingsRevealLookup =>
        s.kratos_info_self_service_settings_reveal_lookup,
      KratosError.infoSelfServiceSettingsRegenerateLookup =>
        s.kratos_info_self_service_settings_regenerate_lookup,
      KratosError.infoSelfServiceSettingsLookupSecret =>
        s.kratos_info_self_service_settings_lookup_secret,
      KratosError.infoSelfServiceSettingsLookupSecretLabel =>
        s.kratos_info_self_service_settings_lookup_secret_label,
      KratosError.infoSelfServiceSettingsLookupConfirm =>
        s.kratos_info_self_service_settings_lookup_confirm,
      KratosError.infoSelfServiceSettingsRegisterWebAuthn =>
        s.kratos_info_self_service_settings_register_web_authn,
      KratosError.infoSelfServiceSettingsRegisterWebAuthnDisplayName =>
        s.kratos_info_self_service_settings_register_web_authn_display_name,
      KratosError.infoSelfServiceSettingsLookupSecretUsed =>
        s.kratos_info_self_service_settings_lookup_secret_used,
      KratosError.infoSelfServiceSettingsLookupSecretList =>
        s.kratos_info_self_service_settings_lookup_secret_list,
      KratosError.infoSelfServiceSettingsDisableLookup =>
        s.kratos_info_self_service_settings_disable_lookup,
      KratosError.infoSelfServiceSettingsTOTPSecretLabel =>
        s.kratos_info_self_service_settings_totp_secret_label,
      KratosError.infoSelfServiceSettingsRemoveWebAuthn =>
        s.kratos_info_self_service_settings_remove_web_authn,
      KratosError.infoSelfServiceRecovery =>
        s.kratos_info_self_service_recovery,
      KratosError.infoSelfServiceRecoverySuccessful =>
        s.kratos_info_self_service_recovery_successful,
      KratosError.infoSelfServiceRecoveryEmailSent =>
        s.kratos_info_self_service_recovery_email_sent,
      KratosError.infoSelfServiceRecoveryEmailWithCodeSent =>
        s.kratos_info_self_service_recovery_email_with_code_sent,
      KratosError.infoNodeLabel => s.kratos_info_node_label,
      KratosError.infoNodeLabelInputPassword =>
        s.kratos_info_node_label_input_password,
      KratosError.infoNodeLabelGenerated => s.kratos_info_node_label_generated,
      KratosError.infoNodeLabelSave => s.kratos_info_node_label_save,
      KratosError.infoNodeLabelID => s.kratos_info_node_label_id,
      KratosError.infoNodeLabelSubmit => s.kratos_info_node_label_submit,
      KratosError.infoNodeLabelVerifyOTP => s.kratos_info_node_label_verify_otp,
      KratosError.infoNodeLabelEmail => s.kratos_info_node_label_email,
      KratosError.infoNodeLabelResendOTP => s.kratos_info_node_label_resend_otp,
      KratosError.infoNodeLabelContinue => s.kratos_info_node_label_continue,
      KratosError.infoNodeLabelRecoveryCode =>
        s.kratos_info_node_label_recovery_code,
      KratosError.infoNodeLabelVerificationCode =>
        s.kratos_info_node_label_verification_code,
      KratosError.infoSelfServiceVerification =>
        s.kratos_info_self_service_verification,
      KratosError.infoSelfServiceVerificationEmailSent =>
        s.kratos_info_self_service_verification_email_sent,
      KratosError.infoSelfServiceVerificationSuccessful =>
        s.kratos_info_self_service_verification_successful,
      KratosError.infoSelfServiceVerificationEmailWithCodeSent =>
        s.kratos_info_self_service_verification_email_with_code_sent,
      KratosError.errorValidation => s.kratos_error_validation,
      KratosError.errorValidationGeneric => s.kratos_error_validation_generic,
      KratosError.errorValidationRequired => s.kratos_error_validation_required,
      KratosError.errorValidationMinLength =>
        s.kratos_error_validation_min_length,
      KratosError.errorValidationInvalidFormat =>
        s.kratos_error_validation_invalid_format,
      KratosError.errorValidationPasswordPolicyViolation =>
        s.kratos_error_validation_password_policy_violation,
      KratosError.errorValidationInvalidCredentials =>
        s.kratos_error_validation_invalid_credentials,
      KratosError.errorValidationDuplicateCredentials =>
        s.kratos_error_validation_duplicate_credentials,
      KratosError.errorValidationTOTPVerifierWrong =>
        s.kratos_error_validation_totp_verifier_wrong,
      KratosError.errorValidationIdentifierMissing =>
        s.kratos_error_validation_identifier_missing,
      KratosError.errorValidationAddressNotVerified =>
        s.kratos_error_validation_address_not_verified,
      KratosError.errorValidationNoTOTPDevice =>
        s.kratos_error_validation_no_totp_device,
      KratosError.errorValidationLookupAlreadyUsed =>
        s.kratos_error_validation_lookup_already_used,
      KratosError.errorValidationNoWebAuthnDevice =>
        s.kratos_error_validation_no_web_authn_device,
      KratosError.errorValidationNoLookup =>
        s.kratos_error_validation_no_lookup,
      KratosError.errorValidationSuchNoWebAuthnUser =>
        s.kratos_error_validation_such_no_web_authn_user,
      KratosError.errorValidationLookupInvalid =>
        s.kratos_error_validation_lookup_invalid,
      KratosError.errorValidationMaxLength =>
        s.kratos_error_validation_max_length,
      KratosError.errorValidationMinimum => s.kratos_error_validation_minimum,
      KratosError.errorValidationExclusiveMinimum =>
        s.kratos_error_validation_exclusive_minimum,
      KratosError.errorValidationMaximum => s.kratos_error_validation_maximum,
      KratosError.errorValidationExclusiveMaximum =>
        s.kratos_error_validation_exclusive_maximum,
      KratosError.errorValidationMultipleOf =>
        s.kratos_error_validation_multiple_of,
      KratosError.errorValidationMaxItems =>
        s.kratos_error_validation_max_items,
      KratosError.errorValidationMinItems =>
        s.kratos_error_validation_min_items,
      KratosError.errorValidationUniqueItems =>
        s.kratos_error_validation_unique_items,
      KratosError.errorValidationWrongType =>
        s.kratos_error_validation_wrong_type,
      KratosError.errorValidationDuplicateCredentialsOnOIDCLink =>
        s.kratos_error_validation_duplicate_credentials_on_oidc_link,
      KratosError.errorValidationLogin => s.kratos_error_validation_login,
      KratosError.errorValidationLoginFlowExpired =>
        s.kratos_error_validation_login_flow_expired,
      KratosError.errorValidationLoginNoStrategyFound =>
        s.kratos_error_validation_login_no_strategy_found,
      KratosError.errorValidationRegistrationNoStrategyFound =>
        s.kratos_error_validation_registration_no_strategy_found,
      KratosError.errorValidationSettingsNoStrategyFound =>
        s.kratos_error_validation_settings_no_strategy_found,
      KratosError.errorValidationRecoveryNoStrategyFound =>
        s.kratos_error_validation_recovery_no_strategy_found,
      KratosError.errorValidationVerificationNoStrategyFound =>
        s.kratos_error_validation_verification_no_strategy_found,
      KratosError.errorValidationRegistration =>
        s.kratos_error_validation_registration,
      KratosError.errorValidationRegistrationFlowExpired =>
        s.kratos_error_validation_registration_flow_expired,
      KratosError.errorValidationSettings => s.kratos_error_validation_settings,
      KratosError.errorValidationSettingsFlowExpired =>
        s.kratos_error_validation_settings_flow_expired,
      KratosError.errorValidationRecovery => s.kratos_error_validation_recovery,
      KratosError.errorValidationRecoveryRetrySuccess =>
        s.kratos_error_validation_recovery_retry_success,
      KratosError.errorValidationRecoveryStateFailure =>
        s.kratos_error_validation_recovery_state_failure,
      KratosError.errorValidationRecoveryMissingRecoveryToken =>
        s.kratos_error_validation_recovery_missing_recovery_token,
      KratosError.errorValidationRecoveryTokenInvalidOrAlreadyUsed =>
        s.kratos_error_validation_recovery_token_invalid_or_already_used,
      KratosError.errorValidationRecoveryFlowExpired =>
        s.kratos_error_validation_recovery_flow_expired,
      KratosError.errorValidationRecoveryCodeInvalidOrAlreadyUsed =>
        s.kratos_error_validation_recovery_code_invalid_or_already_used,
      KratosError.errorValidationVerification =>
        s.kratos_error_validation_verification,
      KratosError.errorValidationVerificationTokenInvalidOrAlreadyUsed =>
        s.kratos_error_validation_verification_token_invalid_or_already_used,
      KratosError.errorValidationVerificationRetrySuccess =>
        s.kratos_error_validation_verification_retry_success,
      KratosError.errorValidationVerificationStateFailure =>
        s.kratos_error_validation_verification_state_failure,
      KratosError.errorValidationVerificationMissingVerificationToken =>
        s.kratos_error_validation_verification_missing_verification_token,
      KratosError.errorValidationVerificationFlowExpired =>
        s.kratos_error_validation_verification_flow_expired,
      KratosError.errorValidationVerificationCodeInvalidOrAlreadyUsed =>
        s.kratos_error_validation_verification_code_invalid_or_already_used,
      KratosError.errorSystem => s.kratos_error_system,
      KratosError.errorSystemGeneric => s.kratos_error_system_generic
    };
  }
}
