import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SimulationBottomNav extends StatelessWidget {
  const SimulationBottomNav({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark
        ? SovereignPalette.simulationDarkText
        : SovereignPalette.simulationLightButton;
    final inactiveColor =
        isDark ? SovereignPalette.simulationDarkMuted : SovereignPalette.simulationLightMutedSoft;

    final tabs = <_NavItemData>[
      const _NavItemData(label: 'Home', iconSvg: _homeSvg, active: true),
      const _NavItemData(label: 'Map', iconSvg: _mapSvg, active: false),
      const _NavItemData(label: 'Reports', iconSvg: _reportSvg, active: false),
      const _NavItemData(label: 'Alerts', iconSvg: _alertSvg, active: false),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark
            ? SovereignPalette.simulationDarkBackground
            : SovereignPalette.simulationLightApp,
        border: Border(
          top: BorderSide(
            color: isDark
                ? SovereignPalette.simulationDarkBorder.withValues(alpha: 0.5)
                : SovereignPalette.simulationLightBorder,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(24, isDark ? 10 : 8, 24, isDark ? 8 : 14),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: tabs.map((tab) {
                  final tabColor = tab.active ? activeColor : inactiveColor;
                  return _NavTab(
                    label: tab.label,
                    iconSvg: tab.iconSvg,
                    color: tabColor,
                    isDark: isDark,
                  );
                }).toList(growable: false),
              ),
              SizedBox(height: isDark ? 10 : 8),
              Container(
                width: isDark ? 120 : 128,
                height: 5,
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.5)
                      : Colors.black,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.label,
    required this.iconSvg,
    required this.color,
    required this.isDark,
  });

  final String label;
  final String iconSvg;
  final Color color;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.string(
          iconSvg,
          width: 24,
          height: 24,
          colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _NavItemData {
  const _NavItemData({
    required this.label,
    required this.iconSvg,
    required this.active,
  });

  final String label;
  final String iconSvg;
  final bool active;
}

const String _homeSvg = '''
<svg viewBox="0 0 20 20" fill="currentColor">
  <path d="M10.707 2.293a1 1 0 00-1.414 0l-7 7a1 1 0 001.414 1.414L4 10.414V17a1 1 0 001 1h2a1 1 0 001-1v-2a1 1 0 011-1h2a1 1 0 011 1v2a1 1 0 001 1h2a1 1 0 001-1v-6.586l.293.293a1 1 0 001.414-1.414l-7-7z"/>
</svg>
''';

const String _mapSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7"/>
</svg>
''';

const String _reportSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
</svg>
''';

const String _alertSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
</svg>
''';
