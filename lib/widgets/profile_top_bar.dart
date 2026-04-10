import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class ProfileTopBar extends StatelessWidget {
  const ProfileTopBar({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? SovereignPalette.profileDarkText : SovereignPalette.profileLightText;
    final avatarBorder = isDark ? SovereignPalette.profileDarkBorder : const Color(0xFF9CA3AF);
    final avatarBg = isDark ? const Color(0xFF1F2937) : const Color(0xFFD1D5DB);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isDark ? Icons.shield : Icons.shield,
              color: textColor,
              size: 28,
            ),
            const SizedBox(width: 12),
            Text(
              'SOVEREIGN',
              style: TextStyle(
                color: textColor,
                fontSize: 39 * 0.52,
                fontWeight: FontWeight.w700,
                letterSpacing: 2.0,
              ),
            ),
          ],
        ),
        Container(
          width: isDark ? 38 : 40,
          height: isDark ? 38 : 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: avatarBg,
            border: Border.all(color: avatarBorder, width: 1.5),
          ),
          child: const Icon(
            Icons.person,
            color: Colors.white,
            size: 24,
          ),
        ),
      ],
    );
  }
}
