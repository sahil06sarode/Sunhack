class AppConfig {
  static const String geminiLiveModel = String.fromEnvironment(
    'GEMINI_LIVE_MODEL',
    defaultValue: 'models/gemini-live-3.1',
  );

  static const String defaultRegion = String.fromEnvironment(
    'DEFAULT_REGION',
    defaultValue: 'Global',
  );
}
