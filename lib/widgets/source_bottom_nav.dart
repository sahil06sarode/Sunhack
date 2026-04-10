import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SourceBottomNav extends StatelessWidget {
  const SourceBottomNav({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final background = isDark ? SovereignPalette.sourceDarkNavBackground : SovereignPalette.sourceLightBackground;
    final border = isDark ? SovereignPalette.sourceDarkBorder : SovereignPalette.sourceLightBorder.withValues(alpha: 0.5);
    final inactive = isDark ? SovereignPalette.sourceDarkNavInactive : SovereignPalette.sourceLightNavInactive;
    final active = isDark ? SovereignPalette.sourceDarkNavActive : SovereignPalette.sourceLightNavActive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(20, isDark ? 14 : 10, 20, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.menu, color: inactive, size: 30),
                  Icon(Icons.bolt, color: inactive, size: 30),
                  Container(
                    width: 26,
                    height: 22,
                    decoration: BoxDecoration(
                      color: active,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Icon(Icons.person_outline, color: inactive, size: 30),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: 130,
                height: 6,
                decoration: BoxDecoration(
                  color: active,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
