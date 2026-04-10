import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/result_bullet_list.dart';

class ResultSourcesCard extends StatelessWidget {
  const ResultSourcesCard({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final headingColor =
        isDark ? SovereignPalette.resultDarkHeading : SovereignPalette.resultLightHeading;

    return Container(
      padding: EdgeInsets.fromLTRB(20, isDark ? 24 : 20, 20, isDark ? 24 : 20),
      decoration: BoxDecoration(
        color: isDark ? SovereignPalette.resultDarkCard : SovereignPalette.resultLightSurface,
        borderRadius: BorderRadius.circular(isDark ? 18 : 16),
        border: Border.all(
          color: isDark ? SovereignPalette.resultDarkBorder : SovereignPalette.resultLightCardBorder,
        ),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color.fromRGBO(15, 23, 42, 0.06),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sources',
            style: TextStyle(
              color: headingColor,
              fontSize: isDark ? 20 : 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: isDark ? 16 : 14),
          ResultBulletList(
            isDark: isDark,
            itemGap: isDark ? 16 : 12,
            fontSize: isDark ? 17 : 16,
            items: const [
              'UN Security Council Report',
              'Crisis Group Analysis',
              'Regional Intelligence Briefs',
            ],
          ),
        ],
      ),
    );
  }
}
