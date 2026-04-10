import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SourceItemTile extends StatelessWidget {
  const SourceItemTile({
    required this.isDark,
    required this.title,
    required this.tag,
    this.isLast = false,
    super.key,
  });

  final bool isDark;
  final String title;
  final String tag;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? SovereignPalette.sourceDarkText : SovereignPalette.sourceLightText;
    final tagBg = isDark ? SovereignPalette.sourceDarkTagBackground : SovereignPalette.sourceLightTagBackground;
    final tagText = isDark ? SovereignPalette.sourceDarkTagText : SovereignPalette.sourceLightTagText;

    if (isDark) {
      return Container(
        margin: EdgeInsets.only(bottom: isLast ? 0 : 12),
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 18),
        decoration: BoxDecoration(
          color: SovereignPalette.sourceDarkCard,
          borderRadius: BorderRadius.circular(18 * 0.72),
          border: Border.all(color: SovereignPalette.sourceDarkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: titleColor,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.check_circle,
                  color: Colors.white,
                  size: 24,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: tagBg,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                tag,
                style: TextStyle(
                  color: tagText,
                  fontSize: 34 * 0.47,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 24, 0, 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isLast ? Colors.transparent : SovereignPalette.sourceLightBorder.withValues(alpha: 0.6),
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: titleColor,
                    fontSize: 48 * 0.58,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.check_circle,
                color: SovereignPalette.sourceLightText,
                size: 34 * 0.6,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            decoration: BoxDecoration(
              color: tagBg,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              tag,
              style: TextStyle(
                color: tagText,
                fontSize: 34 * 0.47,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
