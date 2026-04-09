class RiskSnapshot {
  RiskSnapshot({
    required this.region,
    required this.riskScore,
    required this.riskLevel,
    required this.confidence,
    required this.forecast24h,
    required this.forecast48h,
    required this.civilianImpact,
    required this.uncertaintyFlag,
    required this.lastUpdated,
    required this.history,
  });

  final String region;
  final double riskScore;
  final String riskLevel;
  final double confidence;
  final String forecast24h;
  final String forecast48h;
  final String civilianImpact;
  final bool uncertaintyFlag;
  final DateTime lastUpdated;
  final List<double> history;

  factory RiskSnapshot.fromMap(Map<String, dynamic> map) {
    return RiskSnapshot(
      region: map['region'] as String? ?? 'Global',
      riskScore: (map['riskScore'] as num?)?.toDouble() ?? 25,
      riskLevel: map['riskLevel'] as String? ?? 'Low',
      confidence: (map['confidence'] as num?)?.toDouble() ?? 50,
      forecast24h: map['24hrForecast'] as String? ?? 'Stable',
      forecast48h: map['48hrForecast'] as String? ?? 'Watch for changes',
      civilianImpact: map['civilianImpact'] as String? ?? 'Low',
      uncertaintyFlag: map['uncertaintyFlag'] as bool? ?? false,
      lastUpdated: DateTime.tryParse(map['lastUpdated'] as String? ?? '') ??
          DateTime.now(),
      history: (map['history'] as List<dynamic>? ?? const [12, 18, 24, 28, 30])
          .map((value) => (value as num).toDouble())
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'region': region,
      'riskScore': riskScore,
      'riskLevel': riskLevel,
      'confidence': confidence,
      '24hrForecast': forecast24h,
      '48hrForecast': forecast48h,
      'civilianImpact': civilianImpact,
      'uncertaintyFlag': uncertaintyFlag,
      'lastUpdated': lastUpdated.toIso8601String(),
      'history': history,
    };
  }
}
