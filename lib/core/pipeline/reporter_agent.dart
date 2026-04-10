import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models.dart';

class ReporterAgent {
  static String get apiKey =>
      dotenv.env['GEMINI_API_KEY'] ?? 'YOUR_TEST_API_KEY_HERE';

  static Future<IntelligenceReport> runReporterAgent(
      RiskAnalysis analysis, List<AnalyzedArticle> articles) async {
    print(
        '[Reporter Agent] Compiling final intelligence report via Gemini for ${analysis.primaryLocation}...');

    final sources = articles.map((a) => a.url).toList();

    try {
      final model =
          GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);

      final inputDataStr = jsonEncode({
        'location': analysis.primaryLocation,
        'riskLevel': analysis.riskLevel,
        'score': analysis.riskScore,
        'events': analysis.eventTypes.keys.toList(),
        'articleSample': articles.take(3).map((a) => a.headline).toList(),
      });

      final prompt = '''
      You are the final Reporter Agent in an Autonomous Intelligence System.      
      Analyze this raw intelligence payload: $inputDataStr

      Perform three actions in your response:
      1. Write a professional, concise executive 1-paragraph summary (3 sentences max) detailing the current situation.
      2. Write an explicit "What-If" scenario simulation projecting what could happen in the next 24-48 hours.
      3. Provide exactly two concise bullet points explaining why the risk score is what it is (Explainability).

      Reply exclusively in this JSON structure:
      {
        "summary": "...",
        "simulation": "...",
        "explainability": ["point 1", "point 2"]
      }
      ''';

      final response = await model.generateContent([Content.text(prompt)]);
      final outputText = response.text ?? '{}';

      final jsonStart = outputText.indexOf('{');
      final jsonEnd = outputText.lastIndexOf('}');
      if (jsonStart == -1 || jsonEnd == -1) {
        throw Exception("No JSON found in response.");
      }

      final jsonStr = outputText.substring(jsonStart, jsonEnd + 1);
      final parsed = jsonDecode(jsonStr);

      return IntelligenceReport(
        timestamp: DateTime.now().toIso8601String(),
        analysis: analysis,
        summary: parsed['summary'] ?? "Summary Unavailable.",
        explainability: List<String>.from(
            parsed['explainability'] ?? ["System detected standard baseline."]),
        simulation: parsed['simulation'] ?? "Scenario data insufficient.",
        sources: sources,
      );
    } catch (e) {
      print('[Reporter Agent Error] Failed to generate AI report. Detailed error: $e');
      throw Exception("Gemini Reporter Failed: $e");
    }
  }
}
