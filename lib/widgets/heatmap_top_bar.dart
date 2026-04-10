import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class HeatmapTopBar extends StatelessWidget {
  const HeatmapTopBar({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? SovereignPalette.heatmapDarkText : SovereignPalette.heatmapLightText;
    final iconColor = isDark ? Colors.white : Colors.black;
    final avatarFill = isDark ? const Color(0xFF1F2937) : const Color(0xFFD1D5DB);
    final avatarBorder = isDark ? SovereignPalette.heatmapDarkBorder : Colors.white;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isDark ? Icons.shield_outlined : Icons.shield,
              color: iconColor,
              size: 30,
            ),
            const SizedBox(width: 14),
            Text(
              'SOVEREIGN',
              style: TextStyle(
                color: textColor,
                fontSize: 39 * 0.53,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        Container(
          width: isDark ? 76 * 0.54 : 40,
          height: isDark ? 76 * 0.54 : 40,
          decoration: BoxDecoration(
            color: avatarFill,
            shape: BoxShape.circle,
            border: Border.all(color: avatarBorder, width: 2),
          ),
          child: Icon(
            Icons.person,
            color: isDark ? SovereignPalette.heatmapDarkMuted : const Color(0xFF1E293B),
            size: isDark ? 22 : 24,
          ),
        ),
      ],
    );
  }
}
