import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class AlertsBottomNav extends StatelessWidget {
  const AlertsBottomNav({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final background = isDark ? SovereignPalette.alertsDarkNav : SovereignPalette.alertsLightSurface;
    final border = isDark ? SovereignPalette.alertsDarkBorder : SovereignPalette.alertsLightBorder;
    final inactive = isDark ? SovereignPalette.alertsDarkMuted : SovereignPalette.alertsLightNavInactive;
    final active = isDark ? SovereignPalette.alertsCritical : SovereignPalette.alertsLightNavActive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border(top: BorderSide(color: border)),
        boxShadow: isDark
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  blurRadius: 20,
                  offset: Offset(0, -6),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.1),
                  blurRadius: 3,
                  offset: Offset(0, -1),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavTab(
                icon: Icons.grid_view_rounded,
                label: 'Home',
                color: inactive,
              ),
              _NavTab(
                icon: Icons.map_outlined,
                label: 'Map',
                color: inactive,
              ),
              _NavTab(
                icon: Icons.description_outlined,
                label: 'Reports',
                color: inactive,
              ),
              _NavTab(
                icon: Icons.warning_amber_rounded,
                label: 'Alerts',
                color: active,
                showDot: true,
                dotColor: active,
                isFilledIcon: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavTab extends StatelessWidget {
  const _NavTab({
    required this.icon,
    required this.label,
    required this.color,
    this.showDot = false,
    this.dotColor,
    this.isFilledIcon = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool showDot;
  final Color? dotColor;
  final bool isFilledIcon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(
                icon,
                color: color,
                size: isFilledIcon ? 24 : 23,
              ),
              if (showDot)
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: dotColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
