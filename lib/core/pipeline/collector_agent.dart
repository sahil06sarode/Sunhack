import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models.dart';

class CollectorAgent {
  static String get tavilyApiKey =>
      (dotenv.env['TAVILY_API_KEY'] ?? '').trim();
  static String get newsApiKey => (dotenv.env['NEWS_API_KEY'] ?? '').trim();

  static Future<List<RawArticle>> runCollectorAgent(
      [String query = 'global conflict']) async {
    print('[Collector Agent] Aggregating multi-source OSINT for: $query...');
    final List<RawArticle> aggregatedArticles = [];

    // 1. TAVILY API SOURCE
    if (tavilyApiKey.isNotEmpty) {
      try {
        final tavilyRes = await http.post(
          Uri.parse('https://api.tavily.com/search'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'api_key': tavilyApiKey,
            'query': 'latest news $query protest conflict tension escalation',
            'search_depth': 'advanced',
            'include_images': false,
            'include_answer': false,
            'extract_depth': 'basic',
            'days': 3,
            'max_results': 5,
          }),
        );

        if (tavilyRes.statusCode == 200) {
          final data = jsonDecode(tavilyRes.body);
          if (data['results'] != null) {
            int index = 0;
            for (var result in data['results']) {
              String sourceName = 'Tavily Source';
              try {
                sourceName = Uri.parse(result['url']).host.replaceAll('www.', '');
              } catch (e) {}

              aggregatedArticles.push(RawArticle(
                id: 'tavily-${DateTime.now().millisecondsSinceEpoch}-$index',
                headline: result['title'] ?? 'Intelligence Brief',
                source: sourceName,
                url: result['url'] ?? '',
                timestamp: DateTime.now().toIso8601String(),
                contentSnippet: result['raw_content'] ?? result['content'] ?? '',
              ));
              index++;
            }
          }
        }
      } catch (e) {
        print('[Collector Agent] Tavily fetch failed: $e');
      }
    } else {
      print('[Collector Agent] TAVILY_API_KEY is missing in .env. Skipping Tavily source.');
    }

    // 2. NEWS API SOURCE
    if (newsApiKey.isNotEmpty) {
      try {
        final newsApiUrl =
            'https://newsapi.org/v2/everything?q=${Uri.encodeComponent(query)}&sortBy=publishedAt&pageSize=5&apiKey=$newsApiKey';
        final newsRes = await http.get(Uri.parse(newsApiUrl));

        if (newsRes.statusCode == 200) {
          final data = jsonDecode(newsRes.body);
          if (data['articles'] != null) {
            int index = 0;
            for (var article in data['articles']) {
              aggregatedArticles.push(RawArticle(
                id: 'newsapi-${DateTime.now().millisecondsSinceEpoch}-$index',
                headline: article['title'] ?? '',
                source: article['source']?['name'] ?? 'NewsAPI',
                url: article['url'] ?? '',
                timestamp:
                    article['publishedAt'] ?? DateTime.now().toIso8601String(),
                contentSnippet:
                    article['description'] ?? article['content'] ?? '',
              ));
              index++;
            }
          }
        }
      } catch (e) {
        print('[Collector Agent] NewsAPI fetch failed: $e');
      }
    }

    // 3. RSS STREAM (Simulated fallback)
    aggregatedArticles.push(RawArticle(
      id: 'rss-${DateTime.now().millisecondsSinceEpoch}-0',
      headline: 'Emergency: Localized unrest detected in $query sectors',
      source: 'Crisis24 RSS Monitor',
      url: 'https://crisis24.garda.com/alerts',
      timestamp: DateTime.now().toIso8601String(),
      contentSnippet:
          'Automated RSS ping triggered due to rapid localized escalation signals from social media chatter.',
    ));

    print(
        '[Collector Agent] Multi-source aggregation complete. Gathered ${aggregatedArticles.length} raw datapoints.');
    return aggregatedArticles;
  }
}

// Extension to match JS array push behavior
extension ListExtensions<T> on List<T> {
  void push(T element) => add(element);
}
