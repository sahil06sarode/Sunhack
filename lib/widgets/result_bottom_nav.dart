import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:conflictsense/theme/app_theme.dart';

class ResultBottomNav extends StatelessWidget {
  const ResultBottomNav({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? Colors.white : SovereignPalette.resultLightHeading;
    final inactiveColor =
        isDark ? SovereignPalette.resultDarkInactive : SovereignPalette.resultLightInactive;

    final tabs = <_ResultTabItem>[
      const _ResultTabItem(label: 'Home', iconSvg: _homeGridSvg, active: true),
      const _ResultTabItem(label: 'Map', iconSvg: _compassSvg, active: false),
      const _ResultTabItem(label: 'Reports', iconSvg: _reportSvg, active: false),
      const _ResultTabItem(label: 'Alerts', iconSvg: _alertSvg, active: false),
    ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isDark ? SovereignPalette.resultDarkNav : SovereignPalette.resultLightSurface,
        border: Border(
          top: BorderSide(
            color: isDark ? SovereignPalette.resultDarkBorder : SovereignPalette.resultLightNavBorder,
          ),
        ),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 6,
                  offset: Offset(0, -4),
                ),
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.03),
                  blurRadius: 4,
                  offset: Offset(0, -2),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(8, isDark ? 8 : 6, 8, isDark ? 10 : 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: tabs.map((tab) {
              final color = tab.active ? activeColor : inactiveColor;
              return _ResultNavTab(
                label: tab.label,
                iconSvg: tab.iconSvg,
                color: color,
              );
            }).toList(growable: false),
          ),
        ),
      ),
    );
  }
}

class _ResultNavTab extends StatelessWidget {
  const _ResultNavTab({
    required this.label,
    required this.iconSvg,
    required this.color,
  });

  final String label;
  final String iconSvg;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(
            iconSvg,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultTabItem {
  const _ResultTabItem({
    required this.label,
    required this.iconSvg,
    required this.active,
  });

  final String label;
  final String iconSvg;
  final bool active;
}

const String _homeGridSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <rect x="3" y="3" width="7" height="7"/>
  <rect x="14" y="3" width="7" height="7"/>
  <rect x="14" y="14" width="7" height="7"/>
  <rect x="3" y="14" width="7" height="7"/>
</svg>
''';

const String _compassSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <circle cx="12" cy="12" r="10"/>
  <polygon points="16.24 7.76 14.12 14.12 7.76 16.24 9.88 9.88 16.24 7.76"/>
</svg>
''';

const String _reportSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
</svg>
''';

const String _alertSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
</svg>
''';
