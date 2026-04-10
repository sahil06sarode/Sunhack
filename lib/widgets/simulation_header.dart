import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SimulationHeader extends StatelessWidget {
  const SimulationHeader({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isDark ? SovereignPalette.simulationDarkBackground : SovereignPalette.simulationLightApp;
    final borderColor =
        isDark ? SovereignPalette.simulationDarkBorder.withValues(alpha: 0.5) : SovereignPalette.simulationLightBorder;
    final textColor =
        isDark ? SovereignPalette.simulationDarkText : SovereignPalette.simulationLightNavy;
    final mutedColor =
        isDark ? SovereignPalette.simulationDarkMuted : SovereignPalette.simulationLightNavy;

    return Container(
      color: backgroundColor,
      padding: EdgeInsets.fromLTRB(24, isDark ? 16 : 20, 24, isDark ? 16 : 20),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: borderColor)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                'S',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: isDark ? 1.3 : 2.0,
                  color: textColor,
                ),
              ),
              const SizedBox(width: 4),
              SvgPicture.string(
                _globeSvg,
                width: 20,
                height: 20,
                colorFilter: ColorFilter.mode(
                  isDark
                      ? SovereignPalette.simulationDarkTeal
                      : SovereignPalette.simulationLightTeal,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'VEREIGN',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: isDark ? 1.3 : 2.0,
                  color: textColor,
                ),
              ),
            ],
          ),
          SvgPicture.string(
            _profileSvg,
            width: isDark ? 24 : 28,
            height: isDark ? 24 : 28,
            colorFilter: ColorFilter.mode(mutedColor, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}

const String _globeSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"/>
</svg>
''';

const String _profileSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M5.121 17.804A13.937 13.937 0 0112 16c2.5 0 4.847.655 6.879 1.804M15 10a3 3 0 11-6 0 3 3 0 016 0zm6 2a9 9 0 11-18 0 9 9 0 0118 0z"/>
</svg>
''';
