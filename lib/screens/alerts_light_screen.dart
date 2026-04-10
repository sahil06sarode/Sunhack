import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/alerts_bottom_nav.dart';
import 'package:conflictsense/widgets/alerts_filter_chips.dart';
import 'package:conflictsense/widgets/alerts_item_card.dart';
import 'package:conflictsense/widgets/alerts_summary_cards.dart';
import 'package:conflictsense/widgets/alerts_top_bar.dart';

class AlertsLightScreen extends StatelessWidget {
  const AlertsLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.alertsLightBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: const Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AlertsTopBar(isDark: false),
                        SizedBox(height: 26),
                        Text(
                          'Active Alerts',
                          style: TextStyle(
                            fontSize: 54 * 0.62,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                            color: SovereignPalette.alertsLightText,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Modern intelligence and conflict prediction system.',
                          style: TextStyle(
                            fontSize: 34 * 0.48,
                            height: 1.35,
                            color: SovereignPalette.alertsLightMuted,
                          ),
                        ),
                        SizedBox(height: 22),
                        AlertsSummaryCards(isDark: false),
                        SizedBox(height: 16),
                        AlertsFilterChips(isDark: false),
                        SizedBox(height: 16),
                        AlertsItemCard(
                          isDark: false,
                          severity: AlertSeverity.critical,
                          id: 'SIG-8829',
                          title: 'Unauthorized Border Incursion - Sector 7G',
                          location: 'Northern Perimeter, Baltia',
                          timeAgo: '2m ago',
                        ),
                        SizedBox(height: 12),
                        AlertsItemCard(
                          isDark: false,
                          severity: AlertSeverity.elevated,
                          id: 'CYB-4410',
                          title: 'Coordinated Social Engineering Campaign',
                          location: 'Network Infrastructure',
                          timeAgo: '14m ago',
                        ),
                        SizedBox(height: 12),
                        AlertsItemCard(
                          isDark: false,
                          severity: AlertSeverity.stable,
                          id: 'LOG-1102',
                          title: 'Supply Route Restoration Confirmed',
                          location: 'Southern Corridor',
                          timeAgo: '1h 22m ago',
                        ),
                        SizedBox(height: 24),
                        _ArchiveButton(isDark: false),
                      ],
                    ),
                  ),
                ),
              ),
              AlertsBottomNav(isDark: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _ArchiveButton extends StatelessWidget {
  const _ArchiveButton({
    required this.isDark,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final background = isDark ? Colors.transparent : SovereignPalette.alertsLightArchiveButton;
    final border = isDark ? SovereignPalette.alertsDarkBorder : const Color(0xFFD1D5DB);
    final textColor = isDark ? SovereignPalette.alertsDarkText : SovereignPalette.alertsLightText;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Access Archived Intelligence',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: textColor,
          fontSize: 36 * 0.53,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
