export type SentimentLabel = 'positive' | 'negative' | 'neutral';

export interface RawArticle {
  id: string;
  headline: string;
  snippet: string;
  source: string;
  url: string;
  publishedAt: string;
  region: string;
}

export interface CleanArticle extends RawArticle {
  cleanedText: string;
  keywords: string[];
}

export interface AnalyzedArticle extends CleanArticle {
  sentiment: SentimentLabel;
  sentimentConfidence: number;
  eventType: 'protest' | 'clash' | 'tension' | 'displacement' | 'ceasefire';
  eventSeverity: number;
  location: string;
}

export interface Prediction {
  region: string;
  riskScore: number;
  riskLevel: 'Low' | 'Medium' | 'High' | 'Critical';
  confidence: number;
  forecast24h: string;
  forecast48h: string;
  civilianImpact: 'Low' | 'Medium' | 'High';
  uncertaintyFlag: boolean;
}

export interface ReportResult {
  id: string;
  region: string;
  summary: string;
  analysis: string;
  explainability: string[];
  scenario: string;
  sources: string[];
  createdAt: string;
}
