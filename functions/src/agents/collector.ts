import {fetchNewsSources} from '../services/newsSources';
import {RawArticle} from '../types';

export async function collectorAgent(region: string): Promise<RawArticle[]> {
  return fetchNewsSources(region);
}
