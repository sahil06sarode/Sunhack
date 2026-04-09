import {initializeApp} from 'firebase-admin/app';
import {getFirestore} from 'firebase-admin/firestore';
import {onRequest} from 'firebase-functions/v2/https';
import {onSchedule} from 'firebase-functions/v2/scheduler';
import * as logger from 'firebase-functions/logger';

import {analyzerAgent} from './agents/analyzer';
import {requireAuthenticatedUser} from './auth';
import {cleanerAgent} from './agents/cleaner';
import {collectorAgent} from './agents/collector';
import {predictorAgent} from './agents/predictor';
import {reporterAgent} from './agents/reporter';
import {createLiveSessionResponse} from './services/liveSession';

initializeApp();
const db = getFirestore();

export const ingestNews = onSchedule('every 15 minutes', async () => {
  await runPipeline('Global');
});

export const runConflictPipeline = onRequest({cors: true}, async (request, response) => {
  try {
    if (request.method !== 'POST') {
      response.status(405).json({ok: false, error: 'Method not allowed'});
      return;
    }

    const user = await requireAuthenticatedUser(request, response);
    if (!user) {
      return;
    }

    const inputRegion = request.body?.region;
    const region =
      typeof inputRegion === 'string' && inputRegion.trim().length > 0
        ? inputRegion.trim().slice(0, 60)
        : 'Global';

    logger.info('runConflictPipeline requested', {uid: user.uid, region});
    const result = await runPipeline(region);
    response.status(200).json({ok: true, ...result});
  } catch (error) {
    logger.error('runConflictPipeline failed', error as Error);
    response.status(500).json({ok: false, error: String(error)});
  }
});

export const createGeminiLiveSession = onRequest({cors: true}, async (request, response) => {
  try {
    if (request.method !== 'POST') {
      response.status(405).json({error: 'Method not allowed'});
      return;
    }

    const user = await requireAuthenticatedUser(request, response);
    if (!user) {
      return;
    }

    logger.info('createGeminiLiveSession requested', {uid: user.uid});
    const session = createLiveSessionResponse();
    response.status(200).json(session);
  } catch (error) {
    logger.error('createGeminiLiveSession failed', error as Error);
    response.status(500).json({error: String(error)});
  }
});

async function runPipeline(region: string): Promise<{riskScore: number; riskLevel: string}> {
  logger.info('Pipeline started', {region});

  const raw = await collectorAgent(region);
  const clean = cleanerAgent(raw);
  const analyzed = await analyzerAgent(clean);
  const prediction = predictorAgent(region, analyzed);
  const report = reporterAgent(region, analyzed, prediction);

  const now = new Date().toISOString();

  const batch = db.batch();

  for (const article of analyzed) {
    const docRef = db.collection('articles').doc(article.id);
    batch.set(
      docRef,
      {
        id: article.id,
        headline: article.headline,
        source: article.source,
        url: article.url,
        location: article.location,
        timestamp: article.publishedAt,
        sentiment: article.sentiment,
        keywords: article.keywords,
        eventType: article.eventType,
        riskScore: prediction.riskScore,
        region,
      },
      {merge: true},
    );
  }

  batch.set(
    db.collection('riskSnapshots').doc(region),
    {
      region,
      riskScore: prediction.riskScore,
      riskLevel: prediction.riskLevel,
      confidence: prediction.confidence,
      '24hrForecast': prediction.forecast24h,
      '48hrForecast': prediction.forecast48h,
      civilianImpact: prediction.civilianImpact,
      uncertaintyFlag: prediction.uncertaintyFlag,
      lastUpdated: now,
      history: [],
    },
    {merge: true},
  );

  batch.set(db.collection('reports').doc(report.id), report);

  await batch.commit();

  logger.info('Pipeline completed', {
    region,
    raw: raw.length,
    clean: clean.length,
    analyzed: analyzed.length,
    riskScore: prediction.riskScore,
  });

  return {
    riskScore: prediction.riskScore,
    riskLevel: prediction.riskLevel,
  };
}
