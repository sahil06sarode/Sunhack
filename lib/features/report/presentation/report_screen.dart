import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:conflictsense/features/shared/providers/app_providers.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final reportAsync = ref.watch(reportProvider);

    return reportAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(child: Text('Report failed to load: $error')),
      data: (report) {
        if (report == null) {
          return const Center(child: Text('No AI report available yet.'));
        }

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              'Conflict Report: ${report.region}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              'Generated ${DateFormat('dd MMM, HH:mm').format(report.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(report.summary),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(report.analysis),
              ),
            ),
            Card(
              child: ExpansionTile(
                title: const Text('Explainable AI'),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: report.explainability
                    .map((item) => ListTile(
                          dense: true,
                          leading: const Icon(Icons.check_circle_outline),
                          title: Text(item),
                        ))
                    .toList(),
              ),
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scenario simulation',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(report.scenario),
                  ],
                ),
              ),
            ),
            Card(
              child: ExpansionTile(
                title: const Text('Sources'),
                childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                children: report.sources
                    .map((url) => Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(url),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
