import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:conflictsense/features/shared/providers/app_providers.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final articlesAsync = ref.watch(articlesProvider);

    return articlesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Feed failed to load: $error')),
      data: (articles) {
        if (articles.isEmpty) {
          return const Center(child: Text('No live articles yet.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            final sentimentColor = _sentimentColor(article.sentiment);

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.headline,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        Chip(label: Text(article.source)),
                        Chip(
                          label: Text(article.sentiment),
                          backgroundColor: sentimentColor.withValues(alpha: 0.2),
                        ),
                        Chip(label: Text(article.eventType)),
                        Chip(label: Text(article.location)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('dd MMM, HH:mm').format(article.timestamp),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: article.keywords
                          .map((keyword) => Chip(label: Text('#$keyword')))
                          .toList(),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Color _sentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'negative':
        return const Color(0xFFC62828);
      case 'positive':
        return const Color(0xFF2E7D32);
      default:
        return const Color(0xFFF57F17);
    }
  }
}
