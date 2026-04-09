import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class InfoCardPanel extends StatelessWidget {
  const InfoCardPanel({
    required this.title,
    required this.message,
    required this.isDark,
    super.key,
  });

  final String title;
  final String message;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? SovereignPalette.darkSurface : SovereignPalette.lightSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.03),
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      padding: EdgeInsets.all(isDark ? 24 : 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title.toUpperCase(),
            style: isDark
                ? SovereignTextStyles.cardTitleDark
                : SovereignTextStyles.cardTitleLight,
          ),
          const SizedBox(height: 12),
          Text(
            message,
            style:
                isDark ? SovereignTextStyles.cardBodyDark : SovereignTextStyles.cardBodyLight,
          ),
        ],
      ),
    );
  }
}
