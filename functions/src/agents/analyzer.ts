import {AnalyzedArticle, CleanArticle} from '../types';

const NEGATIVE_WORDS = ['clash', 'violence', 'dead', 'injured', 'attack', 'airstrike', 'riot'];
const POSITIVE_WORDS = ['ceasefire', 'dialogue', 'agreement', 'peace', 'mediation'];

export async function analyzerAgent(cleanArticles: CleanArticle[]): Promise<AnalyzedArticle[]> {
  return cleanArticles.map((article) => {
    const text = `${article.headline} ${article.cleanedText}`.toLowerCase();

    const negativeHits = NEGATIVE_WORDS.filter((word) => text.includes(word)).length;
    const positiveHits = POSITIVE_WORDS.filter((word) => text.includes(word)).length;

    let sentiment: 'positive' | 'negative' | 'neutral' = 'neutral';
    if (negativeHits > positiveHits) sentiment = 'negative';
    if (positiveHits > negativeHits) sentiment = 'positive';

    const eventType = detectEventType(text);
    const eventSeverity = severityFromEvent(eventType);

    return {
      ...article,
      sentiment,
      sentimentConfidence: Math.min(95, 55 + Math.abs(negativeHits - positiveHits) * 10),
      eventType,
      eventSeverity,
      location: article.region,
    } as AnalyzedArticle;
  });
}

function detectEventType(text: string):
  | 'protest'
  | 'clash'
  | 'tension'
  | 'displacement'
  | 'ceasefire' {
  if (text.includes('ceasefire')) return 'ceasefire';
  if (text.includes('displacement')) return 'displacement';
  if (text.includes('clash') || text.includes('violence') || text.includes('airstrike')) {
    return 'clash';
  }
  if (text.includes('protest') || text.includes('demonstration')) return 'protest';
  return 'tension';
}

function severityFromEvent(eventType: AnalyzedArticle['eventType']): number {
  switch (eventType) {
    case 'clash':
      return 90;
    case 'displacement':
      return 75;
    case 'protest':
      return 60;
    case 'tension':
      return 45;
    case 'ceasefire':
      return 20;
    default:
      return 50;
  }
}
