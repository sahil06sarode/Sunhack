import 'package:cloud_firestore/cloud_firestore.dart';

class Article {
  Article({
    required this.id,
    required this.headline,
    required this.source,
    required this.url,
    required this.location,
    required this.timestamp,
    required this.sentiment,
    required this.keywords,
    required this.eventType,
    this.riskScore,
  });

  final String id;
  final String headline;
  final String source;
  final String url;
  final String location;
  final DateTime timestamp;
  final String sentiment;
  final List<String> keywords;
  final String eventType;
  final double? riskScore;

  factory Article.fromMap(Map<String, dynamic> map) {
    final rawTimestamp = map['timestamp'];

    DateTime parsedTimestamp;
    if (rawTimestamp is Timestamp) {
      parsedTimestamp = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTimestamp = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else {
      parsedTimestamp = DateTime.now();
    }

    return Article(
      id: map['id'] as String? ?? '',
      headline: map['headline'] as String? ?? 'Untitled',
      source: map['source'] as String? ?? 'Unknown Source',
      url: map['url'] as String? ?? '',
      location: map['location'] as String? ?? 'Unknown',
      timestamp: parsedTimestamp,
      sentiment: map['sentiment'] as String? ?? 'neutral',
      keywords: (map['keywords'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      eventType: map['eventType'] as String? ?? 'tension',
      riskScore: (map['riskScore'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'headline': headline,
      'source': source,
      'url': url,
      'location': location,
      'timestamp': timestamp.toIso8601String(),
      'sentiment': sentiment,
      'keywords': keywords,
      'eventType': eventType,
      'riskScore': riskScore,
    };
  }
}
