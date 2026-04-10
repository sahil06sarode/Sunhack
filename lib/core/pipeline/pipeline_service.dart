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
  static String get apiKey =>
      dotenv.env['GEMINI_API_KEY'] ?? '';

  /// EXECUTING CORE PIPELINE
  static Future<IntelligenceReport> executeCorePipeline(
      [String query = 'global conflict']) async {
    if (apiKey.isEmpty || apiKey == 'YOUR_TEST_API_KEY_HERE') {
      throw Exception("Gemini API key is missing or invalid. Check your .env file!");
    }
    
    print('[Pipeline] Initiating Core Pipeline Execution...');

    final rawArticles = await CollectorAgent.runCollectorAgent(query);
    final cleanArticles = await CleanerAgent.runCleanerAgent(rawArticles);
    final analyzedArticles = await AnalyzerAgent.runAnalyzerAgent(cleanArticles);
    final riskAnalysis = await PredictorAgent.runPredictorAgent(analyzedArticles);
    final intelligenceReport =
        await ReporterAgent.runReporterAgent(riskAnalysis, analyzedArticles);

    // Save report to Firestore to sync with FeedScreen and the rest of the application
    try {
      await FirebaseFirestore.instance
          .collection('intelligence_reports')
          .add(intelligenceReport.toJson());
      print('[Pipeline] Successfully exported report to Firestore.');
    } catch (e) {
      print('[Pipeline Error] Core Pipeline Execution crashed: $e');
      throw Exception('Core Pipeline Failure: $e');
    }

    return intelligenceReport;
  }

  /// THE INTERACTIVE QUERY MODE (Formerly the Cloud Function 'askIntelligenceSystem')
  static Future<String> askIntelligenceSystem(String userQuery) async {
    if (apiKey.isEmpty || apiKey == 'YOUR_TEST_API_KEY_HERE') {
      throw Exception("Gemini API key is not configured. Missing GEMINI_API_KEY in .env.");
    }
    
    if (userQuery.isEmpty) {
      throw Exception('invalid-argument: Query string required.');
    }

    print('[Query Mode] Interacting with Gemini regarding: "$userQuery"');

    // Grab the latest pipeline Context
    String contextData = "No recent intelligence baseline available.";
    try {
      final latestSnapshot = await FirebaseFirestore.instance
          .collection('intelligence_reports')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (latestSnapshot.docs.isNotEmpty) {
        contextData = latestSnapshot.docs[0].data().toString();
      }
    } catch (e) {
      print('[Query Mode Error] Could not fetch firestore context: $e');
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
