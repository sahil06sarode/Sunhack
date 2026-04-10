import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

enum AlertSeverity {
  critical,
  elevated,
  stable,
}

class AlertsItemCard extends StatelessWidget {
  const AlertsItemCard({
    required this.isDark,
    required this.severity,
    required this.id,
    required this.title,
    required this.location,
    required this.timeAgo,
    super.key,
  });

  final bool isDark;
  final AlertSeverity severity;
  final String id;
  final String title;
  final String location;
  final String timeAgo;

  @override
  Widget build(BuildContext context) {
    final cardBackground = isDark ? SovereignPalette.alertsDarkSurface : SovereignPalette.alertsLightSurface;
    final border = isDark ? SovereignPalette.alertsDarkBorder : SovereignPalette.alertsLightBorder;
    final titleColor = isDark ? SovereignPalette.alertsDarkText : SovereignPalette.alertsLightText;
    final bodyColor = isDark ? SovereignPalette.alertsDarkMuted : SovereignPalette.alertsLightMuted;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: border),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Row(
                  children: [
                    _StatusPill(severity: severity, isDark: isDark),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        'ID: $id',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: bodyColor,
                          fontSize: isDark ? 15 : 32 * 0.42,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  border: Border.all(color: border),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.chevron_right,
                  color: bodyColor,
                  size: 24,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: isDark ? 40 * 0.6 : 35 * 0.6,
              fontWeight: FontWeight.w600,
              height: 1.22,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      color: bodyColor,
                      size: 20,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        location,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: bodyColor,
                          fontSize: isDark ? 16 : 34 * 0.48,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Row(
                children: [
                  Icon(
                    Icons.access_time,
                    color: bodyColor,
                    size: 19,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    timeAgo,
                    style: TextStyle(
                      color: bodyColor,
                      fontSize: isDark ? 16 : 34 * 0.48,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({
    required this.severity,
    required this.isDark,
  });

  final AlertSeverity severity;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    Color background;
    Color text;
    Color dot;
    String label;

    switch (severity) {
      case AlertSeverity.critical:
        background = isDark ? SovereignPalette.alertsDarkCriticalBg : SovereignPalette.alertsLightCriticalBg;
        text = isDark ? SovereignPalette.alertsCritical : SovereignPalette.alertsLightCriticalText;
        dot = isDark ? SovereignPalette.alertsCritical : SovereignPalette.alertsLightChipActive;
        label = 'CRITICAL';
      case AlertSeverity.elevated:
        background = isDark ? SovereignPalette.alertsDarkElevatedBg : SovereignPalette.alertsLightElevatedBg;
        text = isDark ? SovereignPalette.alertsElevated : SovereignPalette.alertsLightElevatedText;
        dot = isDark ? SovereignPalette.alertsElevated : const Color(0xFFD49D39);
        label = 'ELEVATED';
      case AlertSeverity.stable:
        background = isDark ? SovereignPalette.alertsDarkStableBg : SovereignPalette.alertsLightStableBg;
        text = isDark ? SovereignPalette.alertsStable : SovereignPalette.alertsLightStableText;
        dot = isDark ? SovereignPalette.alertsStable : const Color(0xFF3B8B5D);
        label = 'STABLE';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: dot,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: text,
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.7,
            ),
          ),
        ],
      ),
    );
  }
}
