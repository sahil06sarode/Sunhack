import 'package:flutter_tts/flutter_tts.dart';

class ReportTtsService {
  ReportTtsService._();

  static final ReportTtsService instance = ReportTtsService._();

  final FlutterTts _tts = FlutterTts();
  bool _isConfigured = false;

  Future<void> _configureIfNeeded() async {
    if (_isConfigured) {
      return;
    }

    await _tts.awaitSpeakCompletion(true);
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.46);
    await _tts.setPitch(1.0);
    await _tts.setVolume(1.0);

    _isConfigured = true;
  }

  Future<void> speak(String text) async {
    final sanitized = text.trim();
    if (sanitized.isEmpty) {
      return;
    }

    await _configureIfNeeded();
    await _tts.stop();
    await _tts.speak(sanitized);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}
