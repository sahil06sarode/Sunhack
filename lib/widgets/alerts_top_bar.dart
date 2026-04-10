import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class AlertsTopBar extends StatelessWidget {
  const AlertsTopBar({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? SovereignPalette.alertsDarkText : SovereignPalette.alertsLightText;
    final avatarBorder = isDark ? SovereignPalette.alertsDarkBorder : SovereignPalette.alertsLightBorder;
    final avatarBg = isDark ? const Color(0xFF111827) : const Color(0xFFE5E7EB);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              Icons.lock,
              color: textColor,
              size: 24,
            ),
            const SizedBox(width: 10),
            Text(
              'SOVEREIGN',
              style: TextStyle(
                color: textColor,
                fontSize: 38 * 0.53,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.2,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Icon(
              Icons.search,
              color: textColor,
              size: 28,
            ),
            const SizedBox(width: 14),
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: avatarBg,
                border: Border.all(color: avatarBorder, width: 2),
              ),
              child: Icon(
                Icons.person,
                color: isDark ? Colors.white : SovereignPalette.alertsLightText,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
