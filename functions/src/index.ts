import * as admin from 'firebase-admin';
import { onRequest, onCall } from 'firebase-functions/v2/https';
import { onSchedule } from 'firebase-functions/v2/scheduler';
import { GoogleGenerativeAI } from '@google/generative-ai';

// Agents Pipeline
import { runCollectorAgent } from './agents/collector';
import { runCleanerAgent } from './agents/cleaner';
import { runAnalyzerAgent } from './agents/analyzer';
import { runPredictorAgent } from './agents/predictor';
import { runReporterAgent } from './agents/reporter';

admin.initializeApp();

const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY || "YOUR_TEST_API_KEY");

/**
 * Core Logic Engine
 */
async function executeCorePipeline(query: string = 'global conflict') {
  const rawArticles = await runCollectorAgent(query);
  const cleanArticles = await runCleanerAgent(rawArticles);
  const analyzedArticles = await runAnalyzerAgent(cleanArticles);
  const riskAnalysis = await runPredictorAgent(analyzedArticles);
  const intelligenceReport = await runReporterAgent(riskAnalysis, analyzedArticles);
  
  await admin.firestore().collection('intelligence_reports').doc().set(intelligenceReport);
  return intelligenceReport;
}

/**
 * MANUAL TRIGGER: Allows forcing pipeline execution via REST
 */
export const runIntelligencePipeline = onRequest(async (req, res) => {
  console.log('[Pipeline] Initiating Manual Run...');
  try {
    const report = await executeCorePipeline(req.query.q as string);
    res.status(200).json(report);
  } catch (error) {
    console.error('[Pipeline Error]', error);
    res.status(500).send('Pipeline execution failed.');
  }
});

/**
 * AUTOMATIC MODE: System runs OSINT sweeps globally every 15 minutes
 */
export const scheduledIntelligenceCollection = onSchedule('every 15 minutes', async (event) => {
  console.log('[Scheduler] Running continuous background OSINT collection...');
  await executeCorePipeline('global conflicts protests and escalation');
});

/**
 * QUERY MODE: The Interactive Agent Call Endpoint (Flutter Chat UI)
 */
export const askIntelligenceSystem = onCall(async (request) => {
  const userQuery = request.data.query;
  if (!userQuery) {
    throw new Error('invalid-argument: Query string required.');
  }

  console.log(`[Query Mode] Interacting with Gemini regarding: "${userQuery}"`);

  // Grab the latest pipeline Context to answer with real-time accuracy
  const latestSnapshot = await admin.firestore()
    .collection('intelligence_reports')
    .orderBy('timestamp', 'desc')
    .limit(1)
    .get();

  let contextData = "No recent intelligence baseline available.";
  if (!latestSnapshot.empty) {
    contextData = JSON.stringify(latestSnapshot.docs[0].data());
  }

  try {
    const model = genAI.getGenerativeModel({ model: "gemini-2.5-flash" });
    const prompt = `
      You are the Autonomous Conflict Intelligence System. You are assisting an analyst querying OSINT data.
      Use this recent baseline intelligence payload to ground your facts:
      ${contextData}

      Analyst Query: ${userQuery}
      
      Respond directly, clinically, and professionally. Omit markdown formatting inside sentences. Mention if the system lacks sufficient tracking on the specific event.
    `;

    const response = await model.generateContent(prompt);
    return { answer: response.response.text() };
  } catch (error) {
    console.error('[Query Mode Error]', error);
    throw new Error('internal: AI system failure.');
  }
});
