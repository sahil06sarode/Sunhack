import 'package:flutter/material.dart';

enum AiBlockType {
  text,
  highlight,
  brainstorm,
  simulation,
  feed,
  expandable,
}

AiBlockType parseAiBlockType(String rawType) {
  switch (rawType.trim().toLowerCase()) {
    case 'highlight':
      return AiBlockType.highlight;
    case 'brainstorm':
      return AiBlockType.brainstorm;
    case 'simulation':
      return AiBlockType.simulation;
    case 'feed':
      return AiBlockType.feed;
    case 'expandable':
      return AiBlockType.expandable;
    default:
      return AiBlockType.text;
  }
}

class MiniToolData {
  const MiniToolData({
    required this.label,
    required this.icon,
    required this.seedPrompt,
  });

  final String label;
  final IconData icon;
  final String seedPrompt;
}

class ResearchFeedItem {
  const ResearchFeedItem({
    required this.image,
    required this.headline,
    required this.preview,
    required this.content,
    this.category = 'AI Research',
  });

  final String image;
  final String headline;
  final String preview;
  final String content;
  final String category;

  factory ResearchFeedItem.fromMap(
    Map<String, dynamic> map, {
    required int index,
  }) {
    return ResearchFeedItem(
      image: (map['image'] as String?)?.trim().isNotEmpty == true
          ? (map['image'] as String).trim()
          : 'https://picsum.photos/seed/research-feed-$index/1200/720',
      headline: (map['headline'] as String?)?.trim() ??
          (map['title'] as String?)?.trim() ??
          'AI Research Insight',
      preview: (map['preview'] as String?)?.trim() ??
          (map['description'] as String?)?.trim() ??
          'Tap to open this AI-generated research suggestion.',
      content: (map['content'] as String?)?.trim() ??
          'Detailed research content is not available for this suggestion yet.',
      category: (map['category'] as String?)?.trim() ?? 'AI Research',
    );
  }
}

class SimulationScenario {
  const SimulationScenario({
    required this.title,
    required this.outcome,
    required this.pros,
    required this.cons,
  });

  final String title;
  final String outcome;
  final List<String> pros;
  final List<String> cons;

  factory SimulationScenario.fromMap(Map<String, dynamic> map) {
    return SimulationScenario(
      title: (map['title'] as String?)?.trim() ?? 'Scenario',
      outcome: (map['outcome'] as String?)?.trim() ?? 'Outcome unavailable.',
      pros: _toStringList(map['pros']),
      cons: _toStringList(map['cons']),
    );
  }

  static List<String> _toStringList(dynamic raw) {
    if (raw is! List) {
      return const [];
    }

    return raw
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}

class AiResponseBlock {
  const AiResponseBlock({
    required this.type,
    this.title = '',
    this.text = '',
    this.ideas = const [],
    this.scenarios = const [],
    this.feedItems = const [],
  });

  final AiBlockType type;
  final String title;
  final String text;
  final List<String> ideas;
  final List<SimulationScenario> scenarios;
  final List<ResearchFeedItem> feedItems;

  factory AiResponseBlock.fromMap(
    Map<String, dynamic> map, {
    required int index,
  }) {
    final type = parseAiBlockType((map['type'] as String?) ?? 'text');

    final ideas = _toStringList(map['ideas']);
    final scenariosRaw = map['scenarios'];
    final feedRaw = map['items'] ?? map['feedItems'];

    final scenarios = scenariosRaw is List
        ? scenariosRaw
            .whereType<Map<String, dynamic>>()
            .map(SimulationScenario.fromMap)
            .toList()
        : const <SimulationScenario>[];

    final feedItems = feedRaw is List
        ? feedRaw
            .whereType<Map<String, dynamic>>()
            .toList()
            .asMap()
            .entries
            .map(
              (entry) => ResearchFeedItem.fromMap(
                entry.value,
                index: index + entry.key,
              ),
            )
            .toList()
        : const <ResearchFeedItem>[];

    return AiResponseBlock(
      type: type,
      title: (map['title'] as String?)?.trim() ?? '',
      text: (map['content'] as String?)?.trim() ??
          (map['text'] as String?)?.trim() ??
          '',
      ideas: ideas,
      scenarios: scenarios,
      feedItems: feedItems,
    );
  }

  static List<String> _toStringList(dynamic raw) {
    if (raw is! List) {
      return const [];
    }

    return raw
        .map((item) => item.toString().trim())
        .where((item) => item.isNotEmpty)
        .toList();
  }
}

class ChatMessage {
  const ChatMessage({
    required this.isUser,
    this.text = '',
    this.blocks = const [],
  });

  final bool isUser;
  final String text;
  final List<AiResponseBlock> blocks;
}

class ChatContextTurn {
  const ChatContextTurn({
    required this.role,
    required this.text,
  });

  final String role;
  final String text;
}
