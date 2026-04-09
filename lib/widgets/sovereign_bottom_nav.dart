import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SovereignBottomNav extends StatelessWidget {
  const SovereignBottomNav({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final tabs = <_TabItemData>[
      _TabItemData(
        label: 'Home',
        iconSvg: isDark ? _darkHomeSvg : _lightHomeSvg,
        active: true,
      ),
      _TabItemData(
        label: 'Map',
        iconSvg: isDark ? _darkMapSvg : _lightMapSvg,
        active: false,
      ),
      _TabItemData(
        label: 'Reports',
        iconSvg: isDark ? _darkReportSvg : _lightReportSvg,
        active: false,
      ),
      _TabItemData(
        label: 'Alerts',
        iconSvg: isDark ? _darkAlertSvg : _lightAlertSvg,
        active: false,
      ),
    ];

    if (isDark) {
      return Container(
        decoration: const BoxDecoration(
          color: SovereignPalette.darkNavBackground,
          border: Border(
            top: BorderSide(color: Color.fromRGBO(46, 58, 80, 0.5), width: 1),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: tabs
                  .map((tab) => _BottomNavTab(
                        data: tab,
                        isDark: true,
                        minWidth: 64,
                      ))
                  .toList(growable: false),
            ),
          ),
        ),
      );
    }

    final wide = MediaQuery.of(context).size.width >= 640;
    final gap = wide ? 56.0 : 40.0;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _BottomNavTab(data: tabs[0], isDark: false),
            SizedBox(width: gap),
            _BottomNavTab(data: tabs[1], isDark: false),
            SizedBox(width: gap),
            _BottomNavTab(data: tabs[2], isDark: false),
            SizedBox(width: gap),
            _BottomNavTab(data: tabs[3], isDark: false),
          ],
        ),
      ),
    );
  }
}

class _BottomNavTab extends StatelessWidget {
  const _BottomNavTab({
    required this.data,
    required this.isDark,
    this.minWidth,
  });

  final _TabItemData data;
  final bool isDark;
  final double? minWidth;

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? SovereignPalette.darkActive : SovereignPalette.lightTextMain;
    final inactiveColor = isDark ? SovereignPalette.darkTextMuted : SovereignPalette.lightTextMuted;
    final color = data.active ? activeColor : inactiveColor;

    return ConstrainedBox(
      constraints: BoxConstraints(minWidth: minWidth ?? 0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.string(
            data.iconSvg,
            width: 24,
            height: 24,
            colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
          ),
          const SizedBox(height: 6),
          Text(
            data.label,
            style: TextStyle(
              fontSize: isDark ? 11 : 12,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabItemData {
  const _TabItemData({
    required this.label,
    required this.iconSvg,
    required this.active,
  });

  final String label;
  final String iconSvg;
  final bool active;
}

const String _lightHomeSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5">
  <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
  <polyline points="9 22 9 12 15 12 15 22"/>
</svg>
''';

const String _lightMapSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5">
  <polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"/>
  <line x1="8" y1="2" x2="8" y2="18"/>
  <line x1="16" y1="6" x2="16" y2="22"/>
</svg>
''';

const String _lightReportSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5">
  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
  <polyline points="14 2 14 8 20 8"/>
  <line x1="16" y1="13" x2="8" y2="13"/>
  <line x1="16" y1="17" x2="8" y2="17"/>
  <polyline points="10 9 9 9 8 9"/>
</svg>
''';

const String _lightAlertSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5">
  <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
  <line x1="12" y1="9" x2="12" y2="13"/>
  <line x1="12" y1="17" x2="12.01" y2="17"/>
</svg>
''';

const String _darkHomeSvg = '''
<svg viewBox="0 0 24 24" fill="currentColor" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M3 9l9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
  <polyline points="9 22 9 12 15 12 15 22"/>
</svg>
''';

const String _darkMapSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <polygon points="1 6 1 22 8 18 16 22 23 18 23 2 16 6 8 2 1 6"/>
  <line x1="8" y1="2" x2="8" y2="18"/>
  <line x1="16" y1="6" x2="16" y2="22"/>
</svg>
''';

const String _darkReportSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"/>
  <polyline points="14 2 14 8 20 8"/>
  <line x1="16" y1="13" x2="8" y2="13"/>
  <line x1="16" y1="17" x2="8" y2="17"/>
  <polyline points="10 9 9 9 8 9"/>
</svg>
''';

const String _darkAlertSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M10.29 3.86L1.82 18a2 2 0 0 0 1.71 3h16.94a2 2 0 0 0 1.71-3L13.71 3.86a2 2 0 0 0-3.42 0z"/>
  <line x1="12" y1="9" x2="12" y2="13"/>
  <line x1="12" y1="17" x2="12.01" y2="17"/>
</svg>
''';
