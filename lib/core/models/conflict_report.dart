class ConflictReport {
  ConflictReport({
    required this.id,
    required this.region,
    required this.summary,
    required this.analysis,
    required this.explainability,
    required this.scenario,
    required this.sources,
    required this.createdAt,
  });

  final String id;
  final String region;
  final String summary;
  final String analysis;
  final List<String> explainability;
  final String scenario;
  final List<String> sources;
  final DateTime createdAt;

  factory ConflictReport.fromMap(Map<String, dynamic> map) {
    return ConflictReport(
      id: map['id'] as String? ?? '',
      region: map['region'] as String? ?? 'Global',
      summary: map['summary'] as String? ?? 'No summary available.',
      analysis: map['analysis'] as String? ?? 'No analysis available.',
      explainability: (map['explainability'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      scenario: map['scenario'] as String? ?? 'No scenario generated.',
      sources: (map['sources'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
      createdAt: DateTime.tryParse(map['createdAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'region': region,
      'summary': summary,
      'analysis': analysis,
      'explainability': explainability,
      'scenario': scenario,
      'sources': sources,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
