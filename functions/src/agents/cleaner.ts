import { RawArticle, CleanArticle } from '../types';

/**
 * Agent 2: Cleaner
 * Removes duplicates, filters noise, formats data.
 */
export async function runCleanerAgent(articles: RawArticle[]): Promise<CleanArticle[]> {
  console.log(`[Cleaner Agent] Processing ${articles.length} raw articles...`);

  // Simple deduplication based on Headline (could use embeddings or URL hashes in production)
  const dedupedMap: Record<string, CleanArticle> = {};
  
  // Basic keyword blocklist for noise filtering (spam, tech news, etc). 
  // We want to KEEP protest, violence, tension, conflict, etc.
  const NOISE_WORDS = ['deal', 'sale', 'tech review']; 

  for (const article of articles) {
    const isNoise = NOISE_WORDS.some(w => article.headline.toLowerCase().includes(w));
    if (isNoise) continue; // Filter out noise
    
    // Hash could be derived via SHA256 of title + body
    const hashLabel = article.headline.trim().toLowerCase(); 

    if (!dedupedMap[hashLabel]) {
      dedupedMap[hashLabel] = {
        ...article,
        hash: hashLabel
      };
    }
  }

  const cleanArticles = Object.values(dedupedMap);
  console.log(`[Cleaner Agent] Retained ${cleanArticles.length} unique, relevant articles.`);
  
  return cleanArticles;
}
