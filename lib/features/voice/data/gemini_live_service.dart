import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:conflictsense/core/config/app_config.dart';

class GeminiLiveSessionConfig {
  GeminiLiveSessionConfig({
    required this.model,
    required this.wsUrl,
    required this.expiresAt,
  });

  final String model;
  final String wsUrl;
  final DateTime expiresAt;

  factory GeminiLiveSessionConfig.fromMap(Map<String, dynamic> map) {
    return GeminiLiveSessionConfig(
      model: map['model'] as String? ?? AppConfig.geminiLiveModel,
      wsUrl: map['wsUrl'] as String? ?? '',
      expiresAt: DateTime.tryParse(map['expiresAt'] as String? ?? '') ??
          DateTime.now().add(const Duration(minutes: 30)),
    );
  }
}

class GeminiLiveService {
  GeminiLiveService({
    http.Client? client,
    FirebaseAuth? auth,
  })  : _client = client ?? http.Client(),
        _auth = auth ?? FirebaseAuth.instance;

  final http.Client _client;
  final FirebaseAuth _auth;
  WebSocketChannel? _channel;

  final StreamController<String> _transcriptController =
      StreamController<String>.broadcast();

  Stream<String> get transcriptStream => _transcriptController.stream;

  bool get isConnected => _channel != null;

  Future<void> start() async {
    final session = await _fetchSessionConfig();
    if (session.wsUrl.isEmpty) {
      throw Exception('Live session URL is empty. Configure backend first.');
    }

    _channel = WebSocketChannel.connect(Uri.parse(session.wsUrl));

    _channel!.stream.listen(
      (event) {
        final text = _extractText(event);
        if (text.isNotEmpty) {
          _transcriptController.add(text);
        }
      },
      onError: (Object error) {
        _transcriptController.add('Live session error: $error');
      },
      onDone: () {
        _channel = null;
      },
    );

    _channel!.sink.add(
      jsonEncode({
        'setup': {
          'model': session.model,
          'generationConfig': {
            'responseModalities': ['TEXT', 'AUDIO']
          }
        }
      }),
    );
  }

  Future<void> sendUserText(String text) async {
    if (_channel == null) {
      throw Exception('Session not started.');
    }

    _channel!.sink.add(
      jsonEncode({
        'clientContent': {
          'turns': [
            {
              'role': 'user',
              'parts': [
                {'text': text}
              ]
            }
          ],
          'turnComplete': true
        }
      }),
    );
  }

  Future<void> stop() async {
    await _channel?.sink.close();
    _channel = null;
  }

  Future<GeminiLiveSessionConfig> _fetchSessionConfig() async {
    final base = AppConfig.backendBaseUrl.trim();
    if (base.isEmpty) {
      throw Exception(
        'BACKEND_BASE_URL is missing. Pass --dart-define=BACKEND_BASE_URL=...',
      );
    }

    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('You must sign in before starting live assistant.');
    }

    final idToken = await user.getIdToken();
    if (idToken == null || idToken.isEmpty) {
      throw Exception('Could not obtain auth token. Please sign in again.');
    }

    final response = await _client.post(
      Uri.parse('$base/createGeminiLiveSession'),
      headers: {
        'content-type': 'application/json',
        'authorization': 'Bearer $idToken',
      },
      body: jsonEncode({
        'model': AppConfig.geminiLiveModel,
      }),
    );

    if (response.statusCode >= 400) {
      throw Exception('Failed to create Gemini Live session: ${response.body}');
    }

    final payload = jsonDecode(response.body) as Map<String, dynamic>;
    return GeminiLiveSessionConfig.fromMap(payload);
  }

  String _extractText(dynamic event) {
    try {
      final data = jsonDecode(event as String) as Map<String, dynamic>;
      final serverContent = data['serverContent'] as Map<String, dynamic>?;
      final modelTurn = serverContent?['modelTurn'] as Map<String, dynamic>?;
      final parts = modelTurn?['parts'] as List<dynamic>?;
      if (parts == null || parts.isEmpty) {
        return '';
      }
      return parts
          .map((part) => (part as Map<String, dynamic>)['text'] as String? ?? '')
          .join(' ')
          .trim();
    } catch (_) {
      return '';
    }
  }

  void dispose() {
    _channel?.sink.close();
    _transcriptController.close();
    _client.close();
  }
}
