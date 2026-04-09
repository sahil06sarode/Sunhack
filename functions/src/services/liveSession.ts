import {config, requireGeminiApiKey} from '../config';

export interface LiveSessionResponse {
  model: string;
  wsUrl: string;
  expiresAt: string;
}

export function createLiveSessionResponse(): LiveSessionResponse {
  const apiKey = requireGeminiApiKey();
  const model = config.geminiLiveModel;

  return {
    model,
    wsUrl:
      'wss://generativelanguage.googleapis.com/ws/google.ai.generativelanguage.v1alpha.GenerativeService.BidiGenerateContent' +
      `?key=${apiKey}`,
    expiresAt: new Date(Date.now() + 45 * 60 * 1000).toISOString(),
  };
}
