import 'dart:math';
import 'models.dart';

class PredictorAgent {
  static Future<RiskAnalysis> runPredictorAgent(
      List<AnalyzedArticle> analyzedSet) async {
    print(
        '[Predictor Agent] Calculating risk based on ${analyzedSet.length} analyzed events...');

    double riskScore = 0;
    final Map<String, int> eventTypesCount = {};

    if (analyzedSet.isEmpty) {
      return RiskAnalysis(
        riskLevel: 'LOW',
        riskScore: 0,
        confidence: 1.0,
        totalAnalyzed: 0,
        eventTypes: {},
        primaryLocation: 'Unknown',
      );
    }

    int negativeCount = 0;

    for (var item in analyzedSet) {
      if (item.sentiment == 'negative') negativeCount++;
      eventTypesCount[item.eventType] =
          (eventTypesCount[item.eventType] ?? 0) + 1;

      if (item.eventType == 'clash') {
        riskScore += 20;
      } else if (item.eventType == 'protest') {
        riskScore += 10;
      } else if (item.eventType == 'tension') {
        riskScore += 5;
      } else if (item.eventType == 'ceasefire') {
        riskScore -= 10;
      }
    }

    final negRatio = negativeCount / analyzedSet.length;
    if (negRatio > 0.5) riskScore += 15;
    if (analyzedSet.length > 5) riskScore += 10;

    riskScore = max(0, min(100, riskScore));

    String riskLevel = 'LOW';
    if (riskScore >= 75) {
      riskLevel = 'CRITICAL';
    } else if (riskScore >= 50) {
      riskLevel = 'HIGH';
    } else if (riskScore >= 25) {
      riskLevel = 'MEDIUM';
    }

    final confidence = analyzedSet.length < 3 ? 0.4 : 0.85;

    return RiskAnalysis(
      riskLevel: riskLevel,
      riskScore: riskScore,
      confidence: confidence,
      totalAnalyzed: analyzedSet.length,
      eventTypes: eventTypesCount,
      primaryLocation:
          analyzedSet.isNotEmpty ? analyzedSet[0].location : 'Global Context',
    );
  }
}
