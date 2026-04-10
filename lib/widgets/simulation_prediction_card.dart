import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SimulationPredictionCard extends StatelessWidget {
  const SimulationPredictionCard({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark
        ? const Color.fromRGBO(71, 85, 105, 0.4)
        : SovereignPalette.simulationLightApp;
    final borderColor = isDark
        ? const Color.fromRGBO(100, 116, 139, 0.3)
        : SovereignPalette.simulationLightBorder;
    final titleColor = isDark
        ? SovereignPalette.simulationDarkText
        : SovereignPalette.simulationLightText;
    final accentColor =
        isDark ? SovereignPalette.simulationDarkElevated : SovereignPalette.simulationLightOrange;
    final trendColor =
        isDark ? SovereignPalette.simulationDarkText : SovereignPalette.simulationLightTextSoft;
    final bodyColor =
        isDark ? SovereignPalette.simulationDarkMuted : SovereignPalette.simulationLightTextSoft;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Predicted Risk Change',
            style: TextStyle(
              fontSize: isDark ? 14 : 16,
              fontWeight: FontWeight.w600,
              color: titleColor,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Elevated',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  color: accentColor,
                  height: 1.1,
                ),
              ),
              const SizedBox(width: 10),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  children: [
                    SvgPicture.string(
                      _trendUpSvg,
                      width: isDark ? 12 : 14,
                      height: isDark ? 12 : 14,
                      colorFilter: ColorFilter.mode(trendColor, BlendMode.srcIn),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '+0.5',
                      style: TextStyle(
                        fontSize: isDark ? 14 : 16,
                        fontWeight: FontWeight.w500,
                        color: trendColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            'Risk level likely to increase in the chosen region due to escalated tensions.',
            style: TextStyle(
              color: bodyColor,
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

const String _trendUpSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M5 10l7-7m0 0l7 7m-7-7v18"/>
</svg>
''';
