import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class AskQuestionBar extends StatelessWidget {
  const AskQuestionBar({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? SovereignPalette.darkInput : SovereignPalette.lightSurface,
        borderRadius: BorderRadius.circular(isDark ? 999 : 32),
        border: isDark
            ? Border.all(color: SovereignPalette.darkBorder, width: 1)
            : null,
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.04),
                  blurRadius: 30,
                  offset: Offset(0, 8),
                ),
              ],
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDark ? 24 : 32,
        vertical: isDark ? 16 : 20,
      ),
      child: TextField(
        decoration: InputDecoration(
          isCollapsed: true,
          hintText: 'Ask a question',
          hintStyle: isDark
              ? SovereignTextStyles.askDarkPlaceholder
              : SovereignTextStyles.askLightPlaceholder,
          border: InputBorder.none,
        ),
        style: isDark ? SovereignTextStyles.askDarkInput : SovereignTextStyles.askLightInput,
      ),
    );
  }
}
