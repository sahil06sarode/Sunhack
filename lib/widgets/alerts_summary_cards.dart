import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class AlertsSummaryCards extends StatelessWidget {
  const AlertsSummaryCards({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _SummaryCard(
            isDark: isDark,
            title: 'CRITICAL',
            value: '03',
            stripe: SovereignPalette.alertsCritical,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _SummaryCard(
            isDark: isDark,
            title: 'ELEVATED',
            value: '12',
            stripe: SovereignPalette.alertsElevated,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.isDark,
    required this.title,
    required this.value,
    required this.stripe,
  });

  final bool isDark;
  final String title;
  final String value;
  final Color stripe;

  @override
  Widget build(BuildContext context) {
    final background = isDark ? SovereignPalette.alertsDarkSurface : SovereignPalette.alertsLightCardTint;
    final border = isDark ? SovereignPalette.alertsDarkBorder : SovereignPalette.alertsLightBorder;
    final labelColor = isDark ? SovereignPalette.alertsDarkMuted : SovereignPalette.alertsLightMuted;
    final valueColor = isDark ? SovereignPalette.alertsDarkText : SovereignPalette.alertsLightText;

    return Container(
      height: isDark ? 140 : 120,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 4,
              decoration: BoxDecoration(
                color: stripe,
                borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: labelColor,
                    fontSize: isDark ? 29 * 0.5 : 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: TextStyle(
                    color: valueColor,
                    fontSize: isDark ? 54 * 0.65 : 48 * 0.65,
                    fontWeight: FontWeight.w700,
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
