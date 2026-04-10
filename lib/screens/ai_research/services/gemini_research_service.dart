import 'dart:async';
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'package:conflictsense/screens/ai_research/models/research_models.dart';

class GeminiResearchService {
  static const String _systemPrompt =
      'You are an advanced research assistant. Provide structured, accurate, and interactive responses. Use cards, highlights, and structured formats instead of plain text.';

  static const String _modelName = 'gemini-2.5-flash';

  Future<Stream<String>> streamStructuredResponse({
    required String userPrompt,
    required List<ChatContextTurn> history,
    required String savedTopic,
  }) async {
    final apiKey = (dotenv.env['GEMINI_API_KEY'] ?? '').trim();
    if (apiKey.isEmpty || apiKey == 'YOUR_TEST_API_KEY_HERE') {
      throw Exception('GEMINI_API_KEY is missing in .env.');
    }

    final model = GenerativeModel(
      model: _modelName,
      apiKey: apiKey,
      generationConfig: GenerationConfig(
        temperature: 0.5,
        maxOutputTokens: 1800,
      ),
    );

    final prompt = _buildPrompt(
      userPrompt: userPrompt,
      history: history,
      savedTopic: savedTopic,
    );

    final contentStream = model.generateContentStream([
      Content.text(prompt),
    ]);

    return _bufferedTextStream(contentStream);
  }

  List<AiResponseBlock> parseStructuredBlocks(String rawText) {
    final candidate = _extractJson(rawText);
    if (candidate == null) {
      return _fallbackBlocks(rawText);
    }

    try {
      final parsed = jsonDecode(candidate);

      if (parsed is Map<String, dynamic>) {
        final blocksRaw = parsed['blocks'];
        if (blocksRaw is List) {
          final blocks = blocksRaw
              .whereType<Map<String, dynamic>>()
              .toList()
              .asMap()
              .entries
              .map(
                (entry) => AiResponseBlock.fromMap(
                  entry.value,
                  index: entry.key,
                ),
              )
              .toList();

          if (blocks.isNotEmpty) {
            return blocks;
          }
        }

        if (parsed.containsKey('type')) {
          return [
            AiResponseBlock.fromMap(parsed, index: 0),
          ];
        }
      }

      if (parsed is List) {
        final blocks = parsed
            .whereType<Map<String, dynamic>>()
            .toList()
            .asMap()
            .entries
            .map(
              (entry) => AiResponseBlock.fromMap(
                entry.value,
                index: entry.key,
              ),
            )
            .toList();

        if (blocks.isNotEmpty) {
          return blocks;
        }
      }
    } catch (_) {
      return _fallbackBlocks(rawText);
    }

    return _fallbackBlocks(rawText);
  }

  String _buildPrompt({
    required String userPrompt,
    required List<ChatContextTurn> history,
    required String savedTopic,
  }) {
    final historyText = history.isEmpty
        ? 'No prior context.'
        : history
            .map((turn) => '${turn.role.toUpperCase()}: ${turn.text}')
            .join('\n');

    return '''
SYSTEM PROMPT:
$_systemPrompt

RESEARCH CONTEXT:
- Selected saved topic: $savedTopic

CONVERSATION MEMORY (latest turns):
$historyText

USER REQUEST:
$userPrompt

STRICT OUTPUT FORMAT:
Return ONLY valid JSON.
Use this schema:
{
  "blocks": [
    {
      "type": "text" | "highlight" | "brainstorm" | "simulation" | "feed" | "expandable",
      "title": "optional title",
      "content": "text content for text/highlight/expandable",
      "ideas": ["idea 1", "idea 2"],
      "scenarios": [
        {
          "title": "scenario name",
          "outcome": "likely outcome",
          "pros": ["pro 1", "pro 2"],
          "cons": ["con 1", "con 2"]
        }
      ],
      "items": [
        {
          "image": "https://...",
          "headline": "feed headline",
          "preview": "short preview",
          "content": "full detailed content",
          "category": "topic"
        }
      ]
    }
  ]
}

RESPONSE RULES:
- Always include at least one "text" or "highlight" block.
- Prefer structured blocks over long paragraphs.
- For strategy/ideas questions, include a "brainstorm" block.
- For uncertainty or forecasting, include a "simulation" block.
- If relevant, include a "feed" block with 2-3 item cards.
''';
  }

  Stream<String> _bufferedTextStream(
    Stream<GenerateContentResponse> contentStream,
  ) async* {
    String buffer = '';

    await for (final chunk in contentStream) {
      final text = chunk.text;
      if (text == null || text.isEmpty) {
        continue;
      }

      buffer += text;
      yield buffer;
    }

    if (buffer.trim().isEmpty) {
      throw Exception('AI returned an empty response.');
    }
  }

  String? _extractJson(String rawText) {
    final fenced = RegExp(
      r'```(?:json)?\s*([\s\S]*?)\s*```',
      multiLine: true,
    ).firstMatch(rawText);

    if (fenced != null) {
      return fenced.group(1)?.trim();
    }

    final trimmed = rawText.trim();
    if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
      return trimmed;
    }

    final start = rawText.indexOf('{');
    final end = rawText.lastIndexOf('}');

    if (start != -1 && end != -1 && end > start) {
      return rawText.substring(start, end + 1).trim();
    }

    return null;
  }

  List<AiResponseBlock> _fallbackBlocks(String rawText) {
    final clean = rawText.trim();

    if (clean.isEmpty) {
      return const [
        AiResponseBlock(
          type: AiBlockType.highlight,
          title: 'No Data',
          text: 'The model returned no readable content for this request.',
        ),
      ];
    }

    return [
      const AiResponseBlock(
        type: AiBlockType.highlight,
        title: 'Structured Response Fallback',
        text:
            'I could not parse a structured response. Showing the raw answer below.',
      ),
      AiResponseBlock(
        type: AiBlockType.expandable,
        title: 'Raw AI Output',
        text: clean,
      ),
    ];
  }
}
