import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:conflictsense/core/models/risk_snapshot.dart';
import 'package:conflictsense/features/shared/providers/app_providers.dart';

class ScenariosScreen extends ConsumerStatefulWidget {
  const ScenariosScreen({super.key});

  @override
  ConsumerState<ScenariosScreen> createState() => _ScenariosScreenState();
}

class _ScenariosScreenState extends ConsumerState<ScenariosScreen> {
  final TextEditingController _controller = TextEditingController();
  RiskSnapshot? _simulation;
  bool _loading = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final region = ref.watch(selectedRegionProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'What-if Simulation',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        const Text(
          'Describe a possible event, and ConflictSense estimates risk impact for the next 24-48 hours.',
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _controller,
          minLines: 3,
          maxLines: 5,
          decoration: const InputDecoration(
            hintText: 'Example: What if ceasefire talks collapse tonight?',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 12),
        FilledButton.icon(
          onPressed: _loading
              ? null
              : () async {
                  if (_controller.text.trim().isEmpty) return;
                  setState(() => _loading = true);
                  final repo = ref.read(conflictRepositoryProvider);
                  final result = await repo.simulateScenario(
                    region: region,
                    userScenario: _controller.text,
                  );
                  if (mounted) {
                    setState(() {
                      _simulation = result;
                      _loading = false;
                    });
                  }
                },
          icon: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(Icons.auto_graph),
          label: const Text('Run Scenario'),
        ),
        const SizedBox(height: 16),
        if (_simulation != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Predicted Risk: ${_simulation!.riskLevel}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text('Risk score: ${_simulation!.riskScore.toStringAsFixed(0)} / 100'),
                  Text('Confidence: ${_simulation!.confidence.toStringAsFixed(0)}%'),
                  Text('24h: ${_simulation!.forecast24h}'),
                  Text('48h: ${_simulation!.forecast48h}'),
                  Text('Civilian impact: ${_simulation!.civilianImpact}'),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
