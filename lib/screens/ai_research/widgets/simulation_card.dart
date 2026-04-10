import 'package:flutter/material.dart';

import 'package:conflictsense/screens/ai_research/models/research_models.dart';
import 'package:conflictsense/theme/app_visual_theme.dart';

class SimulationCard extends StatelessWidget {
  const SimulationCard({
    required this.scenario,
    super.key,
  });

  final SimulationScenario scenario;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppVisualTheme.cardStroke),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.psychology_alt_rounded,
                size: 18,
                color: AppVisualTheme.brandBlue,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  scenario.title,
                  style: const TextStyle(
                    color: AppVisualTheme.ink,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              scenario.outcome,
              style: const TextStyle(
                color: AppVisualTheme.ink,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                height: 1.35,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _ProsConsList(
                  title: 'Pros',
                  items: scenario.pros,
                  color: const Color(0xFF4E9B6D),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _ProsConsList(
                  title: 'Cons',
                  items: scenario.cons,
                  color: const Color(0xFFE3686E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProsConsList extends StatelessWidget {
  const _ProsConsList({
    required this.title,
    required this.items,
    required this.color,
  });

  final String title;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          ...items.take(3).map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    '• $item',
                    style: const TextStyle(
                      color: AppVisualTheme.ink,
                      fontSize: 11,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
