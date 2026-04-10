import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:conflictsense/core/models/article.dart';
import 'package:conflictsense/core/models/conflict_report.dart';
import 'package:conflictsense/core/models/risk_snapshot.dart';

abstract class ConflictRepository {
  Stream<List<Article>> watchLiveArticles(String region);
  Stream<RiskSnapshot> watchRiskSnapshot(String region);
  Stream<ConflictReport?> watchLatestReport(String region);
  Future<RiskSnapshot> simulateScenario({
    required String region,
    required String userScenario,
  });

  Future<void> refresh(String region);
}

class FirestoreConflictRepository implements ConflictRepository {
  FirestoreConflictRepository(this._firestore);

  final FirebaseFirestore _firestore;

  @override
  Stream<List<Article>> watchLiveArticles(String region) {
    final query = _firestore
        .collection('articles')
        .where('region', isEqualTo: region)
        .orderBy('timestamp', descending: true)
        .limit(50);

    return query.snapshots().map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _fallbackArticles(region);
      }

      return snapshot.docs
          .map((doc) => Article.fromMap(doc.data()))
          .toList(growable: false);
    }).handleError((_) => _fallbackArticles(region));
  }

  @override
  Stream<RiskSnapshot> watchRiskSnapshot(String region) {
    return _firestore
        .collection('riskSnapshots')
        .doc(region)
        .snapshots()
        .map((snapshot) {
      final data = snapshot.data();
      if (data == null) {
        return _fallbackRiskSnapshot(region);
      }
      return RiskSnapshot.fromMap(data);
    }).handleError((_) => _fallbackRiskSnapshot(region));
  }

  @override
  Stream<ConflictReport?> watchLatestReport(String region) {
    return _firestore
        .collection('reports')
        .where('region', isEqualTo: region)
        .orderBy('createdAt', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        return _fallbackReport(region);
      }
      return ConflictReport.fromMap(snapshot.docs.first.data());
    }).handleError((_) => _fallbackReport(region));
  }

  @override
  Future<RiskSnapshot> simulateScenario({
    required String region,
    required String userScenario,
  }) async {
    final current = _fallbackRiskSnapshot(region);
    final scenarioText = userScenario.toLowerCase();
    double adjustment = 0;

    if (scenarioText.contains('escalation') || scenarioText.contains('clash')) {
      adjustment += 18;
    }
    if (scenarioText.contains('ceasefire') || scenarioText.contains('dialogue')) {
      adjustment -= 12;
    }

    final simulatedScore = (current.riskScore + adjustment).clamp(0, 100).toDouble();

    return RiskSnapshot(
      region: region,
      riskScore: simulatedScore,
      riskLevel: _levelFromScore(simulatedScore),
      confidence: 58,
      forecast24h: 'Scenario-adjusted forecast active',
      forecast48h: 'Monitor headlines for trend confirmation',
      civilianImpact: simulatedScore > 65 ? 'High' : 'Medium',
      uncertaintyFlag: false,
      lastUpdated: DateTime.now(),
      history: [...current.history, simulatedScore],
    );
  }

  @override
  Future<void> refresh(String region) async {
    // Client-only mode: signal refresh through Firestore control document.
    await _firestore.collection('controls').doc('refresh').set({
      'region': region,
      'requestedAt': DateTime.now().toIso8601String(),
      'client': 'flutter-app',
      'hint': 'trigger-pipeline',
    });
  }

  List<Article> _fallbackArticles(String region) {
    final now = DateTime.now();
    return [
      Article(
        id: 'demo-1',
        headline: 'Protests intensify in central district as security expands checkpoints',
        source: 'Global Wire',
        url: 'https://example.com/demo-1',
        location: region,
        timestamp: now.subtract(const Duration(minutes: 20)),
        sentiment: 'negative',
        keywords: const ['protest', 'checkpoint', 'curfew'],
        eventType: 'protest',
        riskScore: 64,
      ),
      Article(
        id: 'demo-2',
        headline: 'Local mediation talks resume amid weekend ceasefire discussions',
        source: 'Peace Desk',
        url: 'https://example.com/demo-2',
        location: region,
        timestamp: now.subtract(const Duration(hours: 2)),
        sentiment: 'neutral',
        keywords: const ['mediation', 'ceasefire'],
        eventType: 'tension',
        riskScore: 43,
      ),
    ];
  }

  RiskSnapshot _fallbackRiskSnapshot(String region) {
    return RiskSnapshot(
      region: region,
      riskScore: 58,
      riskLevel: 'Medium',
      confidence: 67,
      forecast24h: 'Potential localized flare-ups in next 24 hours',
      forecast48h: 'Watch for spread toward nearby transit corridors',
      civilianImpact: 'Medium',
      uncertaintyFlag: false,
      lastUpdated: DateTime.now(),
      history: const [26, 34, 38, 41, 49, 58],
    );
  }

  ConflictReport _fallbackReport(String region) {
    return ConflictReport(
      id: 'demo-report',
      region: region,
      summary:
          'Risk remains elevated with renewed protest activity and higher negative sentiment in current reporting window.',
      analysis:
          'The latest signal cluster shows repeated mentions of clashes, checkpoint expansions, and crowd-control incidents. Volume and severity remain above trailing baseline.',
      explainability: const [
        '27 relevant articles in the last 6 hours',
        '74% of classified sentiment is negative',
        '3 high-severity event markers detected (clash/violence)',
        'News volume is 2.3x above 7-day baseline',
      ],
      scenario:
          'If escalation continues through the next operational cycle, risk is likely to move from Medium to High with higher civilian mobility disruption.',
      sources: const [
        'https://example.com/demo-1',
        'https://example.com/demo-2',
      ],
      createdAt: DateTime.now(),
    );
  }

  String _levelFromScore(double score) {
    if (score >= 75) return 'High';
    if (score >= 45) return 'Medium';
    return 'Low';
  }
}
