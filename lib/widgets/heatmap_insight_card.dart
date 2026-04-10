import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class HeatmapInsightCard extends StatelessWidget {
  const HeatmapInsightCard({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final background = isDark
        ? SovereignPalette.heatmapDarkCard.withValues(alpha: 0.9)
        : Colors.white.withValues(alpha: 0.95);
    final border = isDark ? SovereignPalette.heatmapDarkBorder : SovereignPalette.heatmapLightCardBorder;
    final title = isDark ? SovereignPalette.heatmapDarkText : SovereignPalette.heatmapLightText;
    final body = isDark ? SovereignPalette.heatmapDarkMuted : const Color(0xFF374151);
    final action = isDark ? SovereignPalette.heatmapDarkMuted : Colors.black;

    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(28 * 0.8),
        border: Border.all(color: border),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.08),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      padding: const EdgeInsets.fromLTRB(28, 24, 28, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Central Sahel Migration Pivot',
            style: TextStyle(
              color: title,
              fontSize: 52 * 0.62,
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Increased intelligence suggests shift in regional corridor usage by organized groups.',
            style: TextStyle(
              color: body,
              fontSize: isDark ? 50 * 0.52 : 44 * 0.54,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'View Details',
            style: TextStyle(
              color: action,
              fontSize: 44 * 0.55,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
