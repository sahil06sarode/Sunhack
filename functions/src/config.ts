export const config = {
  newsApiKey: process.env.NEWS_API_KEY ?? '',
  tavilyApiKey: process.env.TAVILY_API_KEY ?? '',
  geminiApiKey: process.env.GEMINI_API_KEY ?? '',
  geminiTextModel: process.env.GEMINI_TEXT_MODEL ?? 'models/gemini-2.5-flash',
  geminiLiveModel: process.env.GEMINI_LIVE_MODEL ?? 'models/gemini-live-3.1',
  rssFeeds: (process.env.RSS_FEEDS ?? '')
    .split(',')
    .map((item) => item.trim())
    .filter((item) => item.length > 0),
};

export function requireGeminiApiKey(): string {
  if (!config.geminiApiKey) {
    throw new Error('GEMINI_API_KEY is required');
  }
  return config.geminiApiKey;
}
