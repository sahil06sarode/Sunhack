import { CleanArticle, AnalyzedArticle } from '../types';
import { GoogleGenerativeAI } from '@google/generative-ai';

// Retrieve API key from Firebase config or env vars
const API_KEY = process.env.GEMINI_API_KEY || "YOUR_TEST_API_KEY_HERE"; 
const genAI = new GoogleGenerativeAI(API_KEY);

/**
 * Agent 3: Analyzer
 * Extracts sentiment, keywords, location, and classifies events using Gemini.
 */
export async function runAnalyzerAgent(articles: CleanArticle[]): Promise<AnalyzedArticle[]> {
  console.log(`[Analyzer Agent] Summarizing & Extracting data from ${articles.length} articles via Gemini LLM...`);
  
  if (articles.length === 0) return [];

  const analyzed: AnalyzedArticle[] = [];
  
  // Use the Flash model for rapid analytical processing mapped to structured JSON
  const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

  for (const article of articles) {
    try {
      const prompt = `
      You are an elite OSINT Intelligence Agent. 
      Analyze the following article regarding potential global conflicts, protests, or tensions.
      Provide the sentiment (positive, negative, neutral), a confidence score between 0.0 and 1.0, 
      the primary location (City, Country), an event classification (protest, clash, tension, displacement, ceasefire, or unknown), 
      and an array of 3 to 5 critical keywords.

      Headline: "${article.headline}"
      Snippet: "${article.contentSnippet}"
      
      Respond strictly in valid JSON matching this schema:
      {
        "sentiment": "positive" | "negative" | "neutral",
        "confidence": number,
        "location": "City, Country",
        "eventType": "protest" | "clash" | "tension" | "displacement" | "ceasefire" | "unknown",
        "keywords": ["keyword1", "keyword2"]
      }
      `;

      const response = await model.generateContent(prompt);
      const outputText = response.response.text();
      
      // Strip markdown formatting if the LLM provided it
      const jsonStart = outputText.indexOf('{');
      const jsonEnd = outputText.lastIndexOf('}');
      if (jsonStart === -1 || jsonEnd === -1) throw new Error("No JSON found in response.");
      
      const jsonStr = outputText.substring(jsonStart, jsonEnd + 1);
      const parsed = JSON.parse(jsonStr);

      analyzed.push({
        ...article,
        sentiment: parsed.sentiment || 'neutral',
        confidence: parsed.confidence || 0.5,
        location: parsed.location || 'Global Context',
        eventType: parsed.eventType || 'unknown',
        keywords: parsed.keywords || []
      });

    } catch (e) {
      console.warn(`[Analyzer Agent] Gemini extraction failed for article hash ${article.hash}, using fallback.`);
      analyzed.push({
        ...article,
        sentiment: 'neutral',
        confidence: 0.4,
        location: 'Unknown',
        eventType: 'unknown',
        keywords: ['error', 'unverified']
      });
    }
  }

  return analyzed;
}
