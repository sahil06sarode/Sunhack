import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/alerts_bottom_nav.dart';
import 'package:conflictsense/widgets/alerts_filter_chips.dart';
import 'package:conflictsense/widgets/alerts_item_card.dart';
import 'package:conflictsense/widgets/alerts_summary_cards.dart';
import 'package:conflictsense/widgets/alerts_top_bar.dart';

class AlertsDarkScreen extends StatelessWidget {
  const AlertsDarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.alertsDarkBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 592),
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
                        AlertsTopBar(isDark: true),
                        SizedBox(height: 26),
                        Text(
                          'Active Alerts',
                          style: TextStyle(
                            fontSize: 40,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                            color: SovereignPalette.alertsDarkText,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Modern intelligence and conflict prediction system.',
                          style: TextStyle(
                            fontSize: 18,
                            height: 1.3,
                            color: SovereignPalette.alertsDarkMuted,
                          ),
                        ),
                        SizedBox(height: 26),
                        AlertsSummaryCards(isDark: true),
                        SizedBox(height: 18),
                        AlertsFilterChips(isDark: true),
                        SizedBox(height: 16),
                        AlertsItemCard(
                          isDark: true,
                          severity: AlertSeverity.critical,
                          id: 'SIG-8829',
                          title: 'Unauthorized Border Incursion - Sector 7G',
                          location: 'Northern Perimeter, Baltia',
                          timeAgo: '2m ago',
                        ),
                        SizedBox(height: 12),
                        AlertsItemCard(
                          isDark: true,
                          severity: AlertSeverity.elevated,
                          id: 'CYB-4410',
                          title: 'Coordinated Social Engineering Campaign',
                          location: 'Network Infrastructure',
                          timeAgo: '14m ago',
                        ),
                        SizedBox(height: 12),
                        AlertsItemCard(
                          isDark: true,
                          severity: AlertSeverity.stable,
                          id: 'LOG-1102',
                          title: 'Supply Route Restoration Confirmed',
                          location: 'Southern Corridor',
                          timeAgo: '1h 22m ago',
                        ),
                        SizedBox(height: 24),
                        _ArchiveButton(isDark: true),
                      ],
                    ),
                  ),
                ),
              ),
              AlertsBottomNav(isDark: true),
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
          fontSize: 34 * 0.53,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
