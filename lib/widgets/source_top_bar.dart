import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SourceTopBar extends StatelessWidget {
  const SourceTopBar({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? SovereignPalette.sourceDarkText : SovereignPalette.sourceLightText;
    final avatarBg = isDark ? SovereignPalette.sourceDarkCardAlt : const Color(0xFF1E293B);
    final avatarBorder = isDark ? SovereignPalette.sourceDarkBorder : const Color(0xFFD1D5DB);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              isDark ? Icons.shield : Icons.verified_user,
              color: textColor,
              size: 26,
            ),
            const SizedBox(width: 10),
            Text(
              'SOVEREIGN',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
                letterSpacing: 4.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
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
