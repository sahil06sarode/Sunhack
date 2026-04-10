import { AnalyzedArticle, RiskAnalysis } from '../types';

/**
 * Agent 4: Predictor
 * Calculates risk levels based on aggregated event types, sentiment ratio, and volume.
 * Provides basic prediction logic for the pipeline.
 */
export async function runPredictorAgent(analyzedSet: AnalyzedArticle[]): Promise<RiskAnalysis> {
  console.log(`[Predictor Agent] Calculating risk based on ${analyzedSet.length} analyzed events...`);

  // Basic prediction heuristic
  // Weighting params based on negative sentiment & event types
  let riskScore = 0;
  const eventTypesCount: Record<string, number> = {};
  
  if (analyzedSet.length === 0) {
     return {
      riskLevel: 'LOW',
      riskScore: 0,
      confidence: 1.0,
      totalAnalyzed: 0,
      eventTypes: {},
      primaryLocation: 'Unknown',
     };
  }

  let negativeCount = 0;

  for (const item of analyzedSet) {
    if (item.sentiment === 'negative') negativeCount++;
    eventTypesCount[item.eventType] = (eventTypesCount[item.eventType] || 0) + 1;
    
    // Core event weight
    if (item.eventType === 'clash') riskScore += 20;
    else if (item.eventType === 'protest') riskScore += 10;
    else if (item.eventType === 'tension') riskScore += 5;
    else if (item.eventType === 'ceasefire') riskScore -= 10;
  }

  // Volume & Trend Velocity Weight multiplier check
  const negRatio = negativeCount / analyzedSet.length;
  if (negRatio > 0.5) riskScore += 15;
  if (analyzedSet.length > 5) riskScore += 10;

  // Clamp limits 0-100
  riskScore = Math.max(0, Math.min(100, riskScore));

  let riskLevel: RiskAnalysis['riskLevel'] = 'LOW';
  if (riskScore >= 75) riskLevel = 'CRITICAL';
  else if (riskScore >= 50) riskLevel = 'HIGH';
  else if (riskScore >= 25) riskLevel = 'MEDIUM';

  const confidence = analyzedSet.length < 3 ? 0.4 : 0.85;

  return {
    riskLevel,
    riskScore,
    confidence, // Based on dataset size or ML certainty
    totalAnalyzed: analyzedSet.length,
    eventTypes: eventTypesCount,
    primaryLocation: analyzedSet[0]?.location || 'Global Context', // Usually aggregated by region in production
  };
}
