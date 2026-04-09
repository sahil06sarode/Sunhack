import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:conflictsense/features/shared/providers/app_providers.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final riskAsync = ref.watch(riskSnapshotProvider);
    final articlesAsync = ref.watch(articlesProvider);
    final region = ref.watch(selectedRegionProvider);

    return RefreshIndicator(
      onRefresh: () => ref.read(conflictRepositoryProvider).refresh(region),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: region,
                  decoration: const InputDecoration(
                    labelText: 'Region',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Global', child: Text('Global')),
                    DropdownMenuItem(value: 'Sudan', child: Text('Sudan')),
                    DropdownMenuItem(value: 'Ukraine', child: Text('Ukraine')),
                    DropdownMenuItem(value: 'Gaza', child: Text('Gaza')),
                    DropdownMenuItem(value: 'DRC', child: Text('DRC')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      ref.read(selectedRegionProvider.notifier).state = value;
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          riskAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Text('Risk load failed: $error'),
            data: (risk) {
              final color = _riskColor(risk.riskLevel);
              return Column(
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Current Risk: ${risk.riskLevel}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: CircularProgressIndicator(
                                    value: risk.riskScore / 100,
                                    strokeWidth: 14,
                                    color: color,
                                    backgroundColor: color.withValues(alpha: 0.2),
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      risk.riskScore.toStringAsFixed(0),
                                      style:
                                          Theme.of(context).textTheme.headlineMedium,
                                    ),
                                    const Text('/ 100'),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text('24h forecast: ${risk.forecast24h}'),
                          Text('48h forecast: ${risk.forecast48h}'),
                          Text('Civilian impact: ${risk.civilianImpact}'),
                          Text(
                            'Confidence: ${risk.confidence.toStringAsFixed(0)}%',
                          ),
                          if (risk.uncertaintyFlag)
                            const Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: Chip(
                                label: Text('Limited data'),
                                backgroundColor: Color(0xFFFFE2A8),
                              ),
                            ),
                          const SizedBox(height: 8),
                          Text(
                            'Last updated: ${DateFormat('dd MMM, HH:mm').format(risk.lastUpdated)}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Risk Timeline (48h)',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 160,
                            child: LineChart(
                              LineChartData(
                                gridData: const FlGridData(show: true),
                                titlesData: const FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                minY: 0,
                                maxY: 100,
                                lineBarsData: [
                                  LineChartBarData(
                                    isCurved: true,
                                    color: color,
                                    spots: risk.history
                                        .asMap()
                                        .entries
                                        .map((entry) => FlSpot(
                                              entry.key.toDouble(),
                                              entry.value,
                                            ))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 12),
          articlesAsync.when(
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
            data: (articles) {
              final dominantEvent = articles.isEmpty
                  ? 'N/A'
                  : articles.first.eventType.toUpperCase();
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _MetricCell(label: 'Articles', value: '${articles.length}'),
                      _MetricCell(label: 'Event', value: dominantEvent),
                      const _MetricCell(label: 'Refresh', value: 'Pull down'),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Color _riskColor(String level) {
    switch (level.toLowerCase()) {
      case 'high':
      case 'critical':
        return const Color(0xFFC62828);
      case 'medium':
        return const Color(0xFFF57F17);
      default:
        return const Color(0xFF2E7D32);
    }
  }
}

class _MetricCell extends StatelessWidget {
  const _MetricCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 4),
        Text(label),
      ],
    );
  }
}
