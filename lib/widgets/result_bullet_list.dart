import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class ResultBulletList extends StatelessWidget {
  const ResultBulletList({
    required this.items,
    required this.isDark,
    this.itemGap = 12,
    this.fontSize,
    super.key,
  });

  final List<String> items;
  final bool isDark;
  final double itemGap;
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final textColor = isDark ? SovereignPalette.resultDarkBody : SovereignPalette.resultLightBody;

    return Column(
      children: List.generate(items.length, (index) {
        return Padding(
          padding: EdgeInsets.only(bottom: index == items.length - 1 ? 0 : itemGap),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  '.',
                  style: TextStyle(
                    color: textColor,
                    fontSize: (fontSize ?? (isDark ? 32 : 28)) * 0.55,
                    height: 1.1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  items[index],
                  style: TextStyle(
                    color: textColor,
                    fontSize: fontSize ?? (isDark ? 17 : 16),
                    height: 1.45,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
