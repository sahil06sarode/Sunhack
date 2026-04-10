export interface RawArticle {
  id: string;
  headline: string;
  source: string;
  url: string;
  timestamp: string;
  contentSnippet: string;
}

export interface CleanArticle extends RawArticle {
  hash: string;
}

export interface AnalyzedArticle extends CleanArticle {
  sentiment: 'positive' | 'negative' | 'neutral';
  confidence: number;
  location: string;
  eventType: 'protest' | 'clash' | 'tension' | 'displacement' | 'ceasefire' | 'unknown';
  keywords: string[];
}

export interface RiskAnalysis {
  riskLevel: 'LOW' | 'MEDIUM' | 'HIGH' | 'CRITICAL';
  riskScore: number;
  confidence: number;
  totalAnalyzed: number;
  eventTypes: Record<string, number>;
  primaryLocation: string;
}

export interface IntelligenceReport {
  timestamp: string;
  analysis: RiskAnalysis;
  summary: string;
  explainability: string[];
  simulation: string;
  sources: string[];
}
