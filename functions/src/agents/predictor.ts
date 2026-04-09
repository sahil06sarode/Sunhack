import {AnalyzedArticle, Prediction} from '../types';

export function predictorAgent(
  region: string,
  analyzedArticles: AnalyzedArticle[],
): Prediction {
  if (analyzedArticles.length < 3) {
    return {
      region,
      riskScore: 35,
      riskLevel: 'Low',
      confidence: 42,
      forecast24h: 'Not enough data to estimate escalation confidently.',
      forecast48h: 'Collect more signals before directional forecast.',
      civilianImpact: 'Low',
      uncertaintyFlag: true,
    };
  }

  const volumeScore = Math.min(100, analyzedArticles.length * 4);

  const negativeRatio =
    analyzedArticles.filter((item) => item.sentiment === 'negative').length /
    analyzedArticles.length;
  const negativeSentimentScore = Math.min(100, negativeRatio * 100);

  const averageSeverity =
    analyzedArticles.reduce((sum, item) => sum + item.eventSeverity, 0) /
    analyzedArticles.length;

  const trendVelocityScore = computeTrendVelocity(analyzedArticles);

  const riskScore =
    volumeScore * 0.3 +
    negativeSentimentScore * 0.25 +
    averageSeverity * 0.3 +
    trendVelocityScore * 0.15;

  const boundedScore = Math.round(Math.max(0, Math.min(100, riskScore)));

  return {
    region,
    riskScore: boundedScore,
    riskLevel: riskLevelFromScore(boundedScore),
    confidence: Math.round(Math.min(95, 50 + analyzedArticles.length * 1.2)),
    forecast24h: forecast24hFromScore(boundedScore),
    forecast48h: forecast48hFromScore(boundedScore),
    civilianImpact: civilianImpactFromScore(boundedScore),
    uncertaintyFlag: false,
  };
}

function computeTrendVelocity(articles: AnalyzedArticle[]): number {
  const timestamps = articles
    .map((item) => new Date(item.publishedAt).getTime())
    .sort((a, b) => b - a);

  if (timestamps.length < 2) {
    return 30;
  }

  const latestWindow = timestamps.filter(
    (time) => Date.now() - time < 2 * 60 * 60 * 1000,
  ).length;

  return Math.min(100, latestWindow * 20);
}

function riskLevelFromScore(score: number): Prediction['riskLevel'] {
  if (score >= 80) return 'Critical';
  if (score >= 60) return 'High';
  if (score >= 35) return 'Medium';
  return 'Low';
}

function civilianImpactFromScore(score: number): Prediction['civilianImpact'] {
  if (score >= 70) return 'High';
  if (score >= 40) return 'Medium';
  return 'Low';
}

function forecast24hFromScore(score: number): string {
  if (score >= 80) return 'High probability of escalation in next 24 hours.';
  if (score >= 60) return 'Localized escalation likely in next 24 hours.';
  if (score >= 35) return 'Moderate instability expected in next 24 hours.';
  return 'No major escalation signal in next 24 hours.';
}

function forecast48hFromScore(score: number): string {
  if (score >= 80) return 'Sustained high instability expected over 48 hours.';
  if (score >= 60) return 'Escalation may spread regionally over 48 hours.';
  if (score >= 35) return 'Mixed signals with possible flare-ups over 48 hours.';
  return 'Risk appears contained over 48 hours.';
}
