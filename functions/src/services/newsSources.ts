import crypto from 'node:crypto';

import {config} from '../config';
import {RawArticle} from '../types';

export async function fetchNewsSources(region: string): Promise<RawArticle[]> {
  const [newsApi, tavily, rss] = await Promise.all([
    fetchNewsApi(region),
    fetchTavily(region),
    fetchRssFeeds(region),
  ]);

  const combined = [...newsApi, ...tavily, ...rss];
  if (combined.length > 0) {
    return combined;
  }

  return fallbackArticles(region);
}

async function fetchNewsApi(region: string): Promise<RawArticle[]> {
  if (!config.newsApiKey) return [];

  const url = new URL('https://newsapi.org/v2/everything');
  url.searchParams.set('q', `${region} protest OR clash OR violence`);
  url.searchParams.set('language', 'en');
  url.searchParams.set('sortBy', 'publishedAt');
  url.searchParams.set('pageSize', '20');
  url.searchParams.set('apiKey', config.newsApiKey);

  const response = await fetch(url);
  if (!response.ok) return [];

  const data = (await response.json()) as {
    articles?: Array<{
      title?: string;
      description?: string;
      url?: string;
      publishedAt?: string;
      source?: {name?: string};
    }>;
  };

  return (data.articles ?? [])
    .filter((item) => item.url && item.title)
    .map((item) => rawFromItem({
          headline: item.title ?? 'Untitled',
          snippet: item.description ?? '',
          source: item.source?.name ?? 'NewsAPI',
          url: item.url ?? '',
          publishedAt: item.publishedAt ?? new Date().toISOString(),
          region,
        }))
    .filter((item) => item.url.length > 0);
}

async function fetchTavily(region: string): Promise<RawArticle[]> {
  if (!config.tavilyApiKey) return [];

  const response = await fetch('https://api.tavily.com/search', {
    method: 'POST',
    headers: {'content-type': 'application/json'},
    body: JSON.stringify({
      api_key: config.tavilyApiKey,
      query: `${region} conflict protest clash`,
      search_depth: 'advanced',
      max_results: 10,
    }),
  });

  if (!response.ok) return [];

  const data = (await response.json()) as {
    results?: Array<{title?: string; content?: string; url?: string}>;
  };

  return (data.results ?? [])
    .filter((item) => item.url && item.title)
    .map((item) => rawFromItem({
          headline: item.title ?? 'Untitled',
          snippet: item.content ?? '',
          source: 'Tavily',
          url: item.url ?? '',
          publishedAt: new Date().toISOString(),
          region,
        }))
    .filter((item) => item.url.length > 0);
}

async function fetchRssFeeds(region: string): Promise<RawArticle[]> {
  if (config.rssFeeds.length === 0) return [];

  const feeds = await Promise.all(
    config.rssFeeds.map(async (feedUrl) => {
      const response = await fetch(feedUrl);
      if (!response.ok) return '';
      return response.text();
    }),
  );

  return feeds.flatMap((xml, index) => {
    if (!xml) return [];

    const items = xml.split('<item>').slice(1, 8);
    return items.map((item) => {
      const title = between(item, '<title>', '</title>') || 'Untitled';
      const link = between(item, '<link>', '</link>') || '';
      const description = between(item, '<description>', '</description>') || '';
      const pubDate = between(item, '<pubDate>', '</pubDate>') || new Date().toUTCString();

      return rawFromItem({
        headline: sanitize(title),
        snippet: sanitize(description),
        source: `RSS-${index + 1}`,
        url: sanitize(link),
        publishedAt: new Date(pubDate).toISOString(),
        region,
      });
    });
  }).filter((item) => item.url.length > 0);
}

function rawFromItem(input: {
  headline: string;
  snippet: string;
  source: string;
  url: string;
  publishedAt: string;
  region: string;
}): RawArticle {
  const id = crypto
    .createHash('sha256')
    .update(`${input.url}:${input.headline}`)
    .digest('hex')
    .slice(0, 18);

  return {
    id,
    headline: input.headline,
    snippet: input.snippet,
    source: input.source,
    url: input.url,
    publishedAt: input.publishedAt,
    region: input.region,
  };
}

function between(text: string, start: string, end: string): string {
  const startIndex = text.indexOf(start);
  if (startIndex < 0) return '';

  const endIndex = text.indexOf(end, startIndex + start.length);
  if (endIndex < 0) return '';

  return text.slice(startIndex + start.length, endIndex).trim();
}

function sanitize(text: string): string {
  return text
    .replace(/<!\[CDATA\[/g, '')
    .replace(/\]\]>/g, '')
    .replace(/<[^>]+>/g, ' ')
    .replace(/\s+/g, ' ')
    .trim();
}

function fallbackArticles(region: string): RawArticle[] {
  const now = new Date().toISOString();

  return [
    {
      id: 'fallback-1',
      headline: `${region}: Demonstrations grow after overnight incidents`,
      snippet: 'Crowd sizes increased while security presence expanded in central areas.',
      source: 'FallbackWire',
      url: 'https://example.com/fallback-1',
      publishedAt: now,
      region,
    },
    {
      id: 'fallback-2',
      headline: `${region}: Local mediation group calls for de-escalation talks`,
      snippet: 'Community leaders requested a monitored pause in hostilities.',
      source: 'FallbackWire',
      url: 'https://example.com/fallback-2',
      publishedAt: now,
      region,
    },
  ];
}
