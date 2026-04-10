import { AnalyzedArticle, RiskAnalysis, IntelligenceReport } from '../types';
import { GoogleGenerativeAI } from '@google/generative-ai';

const API_KEY = process.env.GEMINI_API_KEY || "YOUR_TEST_API_KEY_HERE";
const genAI = new GoogleGenerativeAI(API_KEY);

/**
 * Agent 5: Reporter
 * Translates risk data into explainable AI insights, sourcing, and what-if simulation using Gemini.
 */
export async function runReporterAgent(
  analysis: RiskAnalysis, 
  articles: AnalyzedArticle[]
): Promise<IntelligenceReport> {
  console.log(`[Reporter Agent] Compiling final intelligence report via Gemini for ${analysis.primaryLocation}...`);

  const sources = articles.map(a => a.url);

  try {
    const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });

    // Payload compression
    const inputDataStr = JSON.stringify({
      location: analysis.primaryLocation,
      riskLevel: analysis.riskLevel,
      score: analysis.riskScore,
      events: Object.keys(analysis.eventTypes),
      articleSample: articles.slice(0, 3).map(a => a.headline) // First 3 headlines
    });

    const prompt = `
    You are the final Reporter Agent in an Autonomous Intelligence System.
    Analyze this raw intelligence payload: ${inputDataStr}

    Perform three actions in your response:
    1. Write a professional, concise executive 1-paragraph summary (3 sentences max) detailing the current situation.
    2. Write an explicit "What-If" scenario simulation projecting what could happen in the next 24-48 hours.
    3. Provide exactly two concise bullet points explaining why the risk score is what it is (Explainability).

    Reply exclusively in this JSON structure:
    {
      "summary": "...",
      "simulation": "...",
      "explainability": ["point 1", "point 2"]
    }
    `;

    const response = await model.generateContent(prompt);
    const outputText = response.response.text();
    
    const jsonStart = outputText.indexOf('{');
    const jsonEnd = outputText.lastIndexOf('}');
    if (jsonStart === -1 || jsonEnd === -1) throw new Error("No JSON found in response.");
    
    const jsonStr = outputText.substring(jsonStart, jsonEnd + 1);
    const parsed = JSON.parse(jsonStr);

    return {
      timestamp: new Date().toISOString(),
      analysis,
      summary: parsed.summary || "Summary Unavailable.",
      explainability: parsed.explainability || ["System detected standard baseline."],
      simulation: parsed.simulation || "Scenario data insufficient.",
      sources
    };
  } catch (e) {
    console.error("[Reporter Agent] Failed to generate AI report, using generic fallback.", e);
    return {
      timestamp: new Date().toISOString(),
      analysis,
      summary: `At the present moment, ${analysis.primaryLocation} is experiencing a ${analysis.riskLevel} risk level based on ${analysis.totalAnalyzed} events.`,
      explainability: ["Elevated risk score calculated mechanically based on data volume."],
      simulation: "Monitoring baseline trends for escalation.",
      sources
    };
  }
}
