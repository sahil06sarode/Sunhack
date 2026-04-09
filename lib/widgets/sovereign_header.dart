import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SovereignHeader extends StatelessWidget {
  const SovereignHeader({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 24,
        vertical: isDark ? 20 : 32,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.string(
                isDark ? _darkShieldSvg : _lightShieldSvg,
                width: 24,
                height: 24,
                colorFilter: ColorFilter.mode(
                  isDark ? SovereignPalette.darkTextMain : SovereignPalette.lightTextMain,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'SOVEREIGN',
                style: isDark
                    ? SovereignTextStyles.brandDark
                    : SovereignTextStyles.brandLight,
              ),
            ],
          ),
          Semantics(
            button: true,
            label: 'User Profile',
            child: Padding(
              padding: const EdgeInsets.all(4),
              child: SvgPicture.string(
                isDark ? _darkProfileSvg : _lightProfileSvg,
                width: isDark ? 24 : 28,
                height: isDark ? 24 : 28,
                colorFilter: ColorFilter.mode(
                  isDark ? SovereignPalette.darkTextMain : const Color(0xFF374151),
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

const String _lightShieldSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
  <path d="M12 2v20"/>
  <path d="M4 12h16"/>
</svg>
''';

const String _darkShieldSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z"/>
  <path d="M12 2v20"/>
</svg>
''';

const String _lightProfileSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5">
  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
  <circle cx="12" cy="7" r="4"/>
</svg>
''';

const String _darkProfileSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"/>
  <circle cx="12" cy="7" r="4"/>
</svg>
''';
