import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class AlertsFilterChips extends StatelessWidget {
  const AlertsFilterChips({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final labels = isDark
        ? const <String>['All', 'High Risk', 'My Regions', 'Archived']
        : const <String>['All', 'High Risk', 'My Regions', 'Refine'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(labels.length, (index) {
          return Padding(
            padding: EdgeInsets.only(right: index == labels.length - 1 ? 0 : 10),
            child: _FilterChip(
              label: labels[index],
              active: index == 0,
              showIcon: labels[index] == 'Refine',
              isDark: isDark,
            ),
          );
        }),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.active,
    required this.showIcon,
    required this.isDark,
  });

  final String label;
  final bool active;
  final bool showIcon;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final background = active
        ? (isDark ? SovereignPalette.alertsDarkChipActive : SovereignPalette.alertsLightChipActive)
        : (isDark ? SovereignPalette.alertsDarkChip : Colors.white);
    final textColor = active
        ? Colors.white
        : (isDark ? SovereignPalette.alertsDarkText : SovereignPalette.alertsLightText);
    final border = isDark ? SovereignPalette.alertsDarkBorder : SovereignPalette.alertsLightBorder;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: active ? Colors.transparent : border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(Icons.filter_alt_outlined, color: textColor, size: 16),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: isDark ? 22 * 0.73 : 28 * 0.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
