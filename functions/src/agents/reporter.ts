import crypto from 'node:crypto';

import {AnalyzedArticle, Prediction, ReportResult} from '../types';

export function reporterAgent(
  region: string,
  analyzedArticles: AnalyzedArticle[],
  prediction: Prediction,
): ReportResult {
  const negativeCount = analyzedArticles.filter(
    (item) => item.sentiment === 'negative',
  ).length;

  const summary =
    `${prediction.riskLevel} risk detected for ${region}. ` +
    `${analyzedArticles.length} relevant articles processed with ` +
    `${negativeCount} negative sentiment signals.`;

  const analysis =
    `Risk score is ${prediction.riskScore}/100. ` +
    `Score combines article volume, negative sentiment ratio, event severity, and short-term trend velocity. ` +
    `Forecast indicates: ${prediction.forecast24h}`;

  const explainability = [
    `${analyzedArticles.length} conflict-relevant articles in active window`,
    `${Math.round((negativeCount / Math.max(1, analyzedArticles.length)) * 100)}% negative sentiment ratio`,
    `Event severity weighted average influences 30% of risk score`,
    `Trend velocity contributes 15% based on recent publication spikes`,
  ];

  const scenario =
    prediction.riskLevel === 'High' || prediction.riskLevel === 'Critical'
      ? 'If escalation continues, displacement pressure and access disruption are likely to increase.'
      : 'If de-escalation narratives strengthen, risk may drop one tier in the next cycle.';

  return {
    id: crypto.randomUUID(),
    region,
    summary,
    analysis,
    explainability,
    scenario,
    sources: analyzedArticles.map((item) => item.url).slice(0, 20),
    createdAt: new Date().toISOString(),
  };
}
