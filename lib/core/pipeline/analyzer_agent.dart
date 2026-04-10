import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models.dart';

class AnalyzerAgent {
  static String get apiKey =>
  (dotenv.env['GEMINI_API_KEY'] ?? '').trim();

  static Future<List<AnalyzedArticle>> runAnalyzerAgent(
      List<CleanArticle> articles) async {
    print(
        '[Analyzer Agent] Summarizing & Extracting data from ${articles.length} articles via Gemini LLM...');

    if (articles.isEmpty) return [];
    if (apiKey.isEmpty) {
      throw Exception('[Analyzer Agent] Missing GEMINI_API_KEY in .env.');
    }

    final model =
        GenerativeModel(model: 'gemini-2.5-flash', apiKey: apiKey);
    final List<AnalyzedArticle> analyzed = [];

    for (var article in articles) {
      try {
        final prompt = '''
        You are an elite OSINT Intelligence Agent. 
        Analyze the following article regarding potential global conflicts, protests, or tensions.
        Provide the sentiment (positive, negative, neutral), a confidence score between 0.0 and 1.0, 
        the primary location (City, Country), an event classification (protest, clash, tension, displacement, ceasefire, or unknown), 
        and an array of 3 to 5 critical keywords.

        Headline: "${article.headline}"
        Snippet: "${article.contentSnippet}"
        
        Respond strictly in valid JSON matching this schema:
        {
          "sentiment": "positive" | "negative" | "neutral",
          "confidence": number,
          "location": "City, Country",
          "eventType": "protest" | "clash" | "tension" | "displacement" | "ceasefire" | "unknown",
          "keywords": ["keyword1", "keyword2"]
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

        analyzed.add(AnalyzedArticle(
          id: article.id,
          headline: article.headline,
          source: article.source,
          url: article.url,
          timestamp: article.timestamp,
          contentSnippet: article.contentSnippet,
          hash: article.hash,
          sentiment: parsed['sentiment'] ?? 'neutral',
          confidence: (parsed['confidence'] as num?)?.toDouble() ?? 0.5,
          location: parsed['location'] ?? 'Global Context',
          eventType: parsed['eventType'] ?? 'unknown',
          keywords: List<String>.from(parsed['keywords'] ?? []),
        ));
      } catch (e) {
        print('[Analyzer Agent Error] Gemini extraction failed for article. Detailed error: $e');
        // Let it throw the real error to pipeline so we stop swallowing the true exception!
        throw Exception("Gemini Analyzer Failed: $e");
      }
    }

    return analyzed;
  }
}
