import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SourceSearchBar extends StatelessWidget {
  const SourceSearchBar({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final background = isDark ? SovereignPalette.sourceDarkCardAlt : SovereignPalette.sourceLightInputBackground;
    final border = isDark ? SovereignPalette.sourceDarkBorder : SovereignPalette.sourceLightBorder;
    final iconColor = isDark ? SovereignPalette.sourceDarkMuted : SovereignPalette.sourceLightMuted;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20 * 0.8),
        border: Border.all(color: border),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.06),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: iconColor, size: 32 * 0.62),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Search sources, agencies, or feeds...',
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: iconColor,
                fontSize: 36 * 0.58,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
