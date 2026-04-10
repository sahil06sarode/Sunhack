import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class ResultRiskBadge extends StatelessWidget {
  const ResultRiskBadge({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isDark ? SovereignPalette.resultDarkRiskBg : SovereignPalette.resultLightRiskBg;
    final textColor =
        isDark ? SovereignPalette.resultDarkRiskText : SovereignPalette.resultLightRiskText;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: isDark ? 20 : 18, vertical: 8),
        child: Text(
          'High Risk',
          style: TextStyle(
            color: textColor,
            fontSize: isDark ? 18 : 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
