import crypto from 'node:crypto';

import {CleanArticle, RawArticle} from '../types';

const WATCH_KEYWORDS = [
  'protest',
  'clash',
  'violence',
  'airstrike',
  'tension',
  'militant',
  'displacement',
  'ceasefire',
  'curfew',
];

export function cleanerAgent(rawArticles: RawArticle[]): CleanArticle[] {
  const seen = new Set<string>();

  return rawArticles
    .map((article) => {
      const cleanedText = `${article.headline} ${article.snippet}`
        .replace(/<[^>]+>/g, ' ')
        .replace(/\s+/g, ' ')
        .trim();

      const fingerprint = crypto
        .createHash('sha256')
        .update(`${article.url}:${article.headline.toLowerCase()}`)
        .digest('hex');

      if (seen.has(fingerprint)) {
        return null;
      }

      seen.add(fingerprint);

      const keywords = WATCH_KEYWORDS.filter((keyword) =>
        cleanedText.toLowerCase().includes(keyword),
      );

      if (keywords.length === 0) {
        return null;
      }

      return {
        ...article,
        cleanedText,
        keywords,
      } as CleanArticle;
    })
    .filter((item): item is CleanArticle => item !== null);
}
