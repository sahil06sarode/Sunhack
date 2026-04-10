import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models.dart';
import 'collector_agent.dart';
import 'cleaner_agent.dart';
import 'analyzer_agent.dart';
import 'predictor_agent.dart';
import 'reporter_agent.dart';

class IntelligencePipelineService {
  static const String _envFileName = '.env';
  static const String _placeholderGeminiKey = 'YOUR_TEST_API_KEY_HERE';

  static Future<void> _refreshEnv() async {
    try {
      await dotenv.load(fileName: _envFileName);
    } catch (_) {
      // Keep existing dotenv state if loading fails so callers get a clear key-validation error next.
    }
  }

  static Future<String> _requireGeminiApiKey() async {
    await _refreshEnv();
    final key = (dotenv.env['GEMINI_API_KEY'] ?? '').trim();
    if (key.isEmpty || key == _placeholderGeminiKey) {
      throw Exception(
        'Gemini API key is missing or invalid. Update GEMINI_API_KEY in .env and fully restart the app.',
      );
    }
    return key;
  }

  /// EXECUTING CORE PIPELINE
  static Future<IntelligenceReport> executeCorePipeline(
      [String query = 'global conflict']) async {
    await _requireGeminiApiKey();
    
    print('[Pipeline] Initiating Core Pipeline Execution...');

    final rawArticles = await CollectorAgent.runCollectorAgent(query);
    final cleanArticles = await CleanerAgent.runCleanerAgent(rawArticles);
    final analyzedArticles = await AnalyzerAgent.runAnalyzerAgent(cleanArticles);
    final riskAnalysis = await PredictorAgent.runPredictorAgent(analyzedArticles);
    final intelligenceReport =
        await ReporterAgent.runReporterAgent(riskAnalysis, analyzedArticles);

    // Persist report in Firebase Firestore (database of record for feed/query context).
    try {
      await FirebaseFirestore.instance
          .collection('intelligence_reports')
          .add(intelligenceReport.toJson());
      print('[Pipeline] Intelligence report saved to Firestore.');
    } catch (e) {
      print('[Pipeline Error] Could not save report to Firestore: $e');
      throw Exception('Core Pipeline Failure: $e');
    }

    return intelligenceReport;
  }

  /// INTERACTIVE QUERY MODE
  static Future<String> askIntelligenceSystem(String userQuery) async {
    final apiKey = await _requireGeminiApiKey();
    
    if (userQuery.isEmpty) {
      throw Exception('invalid-argument: Query string required.');
    }

    print('[Query Mode] Interacting with Gemini regarding: "$userQuery"');

    // Grab the latest pipeline context from Firebase Firestore.
    String contextData = "No recent intelligence baseline available.";
    try {
      final latestSnapshot = await FirebaseFirestore.instance
          .collection('intelligence_reports')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (latestSnapshot.docs.isNotEmpty) {
        contextData = latestSnapshot.docs.first.data().toString();
      }
    } catch (e) {
      print('[Query Mode Error] Could not fetch Firestore context: $e');
    }

    try {
      final model = GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
      final prompt = '''
      You are the Autonomous Conflict Intelligence System. You are assisting an analyst querying OSINT data.
      Use this recent baseline intelligence payload to ground your facts:
      $contextData

      Analyst Query: $userQuery
      
      Respond directly, clinically, and professionally. Omit markdown formatting inside sentences. Mention if the system lacks sufficient tracking on the specific event.
      ''';

      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? "AI system failure.";
    } catch (e) {
      print('[Query Mode Error] $e');
      throw Exception('Gemini API Error: $e');
    }
  }
}
