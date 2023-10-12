class AppConfig {
  AppConfig({
    required this.bugfenderKey,
    required this.configCatSdkKey,
    required this.apiUri,
    required this.pipeUri,
    required this.debugMode,
    required this.kratosUri,
  });

  final String bugfenderKey;
  final String configCatSdkKey;
  final Uri apiUri;
  final Uri pipeUri;
  final bool debugMode;
  final Uri kratosUri;
}
