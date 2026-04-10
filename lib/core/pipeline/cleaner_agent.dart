import 'models.dart';

class CleanerAgent {
  static Future<List<CleanArticle>> runCleanerAgent(
      List<RawArticle> articles) async {
    print('[Cleaner Agent] Processing ${articles.length} raw articles...');

    final Map<String, CleanArticle> dedupedMap = {};
    final List<String> noiseWords = ['deal', 'sale', 'tech review'];

    for (var article in articles) {
      bool isNoise = false;
      for (var word in noiseWords) {
        if (article.headline.toLowerCase().contains(word)) {
          isNoise = true;
          break;
        }
      }

      if (isNoise) continue;

      final hashLabel = article.headline.trim().toLowerCase();

      if (!dedupedMap.containsKey(hashLabel)) {
        dedupedMap[hashLabel] = CleanArticle(
          id: article.id,
          headline: article.headline,
          source: article.source,
          url: article.url,
          timestamp: article.timestamp,
          contentSnippet: article.contentSnippet,
          hash: hashLabel,
        );
      }
    }

    final cleanArticles = dedupedMap.values.toList();
    print(
        '[Cleaner Agent] Retained ${cleanArticles.length} unique, relevant articles.');

    return cleanArticles;
  }
}
