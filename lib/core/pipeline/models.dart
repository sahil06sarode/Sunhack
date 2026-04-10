class RawArticle {
  final String id;
  final String headline;
  final String source;
  final String url;
  final String timestamp;
  final String contentSnippet;

  RawArticle({
    required this.id,
    required this.headline,
    required this.source,
    required this.url,
    required this.timestamp,
    required this.contentSnippet,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'headline': headline,
        'source': source,
        'url': url,
        'timestamp': timestamp,
        'contentSnippet': contentSnippet,
      };

  factory RawArticle.fromJson(Map<String, dynamic> json) {
    return RawArticle(
      id: json['id'] ?? '',
      headline: json['headline'] ?? '',
      source: json['source'] ?? '',
      url: json['url'] ?? '',
      timestamp: json['timestamp'] ?? '',
      contentSnippet: json['contentSnippet'] ?? '',
    );
  }
}

class CleanArticle extends RawArticle {
  final String hash;

  CleanArticle({
    required String id,
    required String headline,
    required String source,
    required String url,
    required String timestamp,
    required String contentSnippet,
    required this.hash,
  }) : super(
          id: id,
          headline: headline,
          source: source,
          url: url,
          timestamp: timestamp,
          contentSnippet: contentSnippet,
        );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'hash': hash,
      };
}

class AnalyzedArticle extends CleanArticle {
  final String sentiment;
  final double confidence;
  final String location;
  final String eventType;
  final List<String> keywords;

  AnalyzedArticle({
    required String id,
    required String headline,
    required String source,
    required String url,
    required String timestamp,
    required String contentSnippet,
    required String hash,
    required this.sentiment,
    required this.confidence,
    required this.location,
    required this.eventType,
    required this.keywords,
  }) : super(
          id: id,
          headline: headline,
          source: source,
          url: url,
          timestamp: timestamp,
          contentSnippet: contentSnippet,
          hash: hash,
        );

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'sentiment': sentiment,
        'confidence': confidence,
        'location': location,
        'eventType': eventType,
        'keywords': keywords,
      };
}

class RiskAnalysis {
  final String riskLevel;
  final double riskScore;
  final double confidence;
  final int totalAnalyzed;
  final Map<String, int> eventTypes;
  final String primaryLocation;

  RiskAnalysis({
    required this.riskLevel,
    required this.riskScore,
    required this.confidence,
    required this.totalAnalyzed,
    required this.eventTypes,
    required this.primaryLocation,
  });

  Map<String, dynamic> toJson() => {
        'riskLevel': riskLevel,
        'riskScore': riskScore,
        'confidence': confidence,
        'totalAnalyzed': totalAnalyzed,
        'eventTypes': eventTypes,
        'primaryLocation': primaryLocation,
      };
}

class IntelligenceReport {
  final String timestamp;
  final RiskAnalysis analysis;
  final String summary;
  final List<String> explainability;
  final String simulation;
  final List<String> sources;

  IntelligenceReport({
    required this.timestamp,
    required this.analysis,
    required this.summary,
    required this.explainability,
    required this.simulation,
    required this.sources,
  });

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp,
        'analysis': analysis.toJson(),
        'summary': summary,
        'explainability': explainability,
        'simulation': simulation,
        'sources': sources,
      };
}
