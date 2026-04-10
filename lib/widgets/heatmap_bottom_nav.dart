import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class HeatmapBottomNav extends StatelessWidget {
  const HeatmapBottomNav({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final background = isDark ? SovereignPalette.heatmapDarkNav : Colors.white;
    final border = isDark ? SovereignPalette.heatmapDarkBorder : SovereignPalette.heatmapLightCardBorder;
    final inactive = isDark ? SovereignPalette.heatmapDarkMuted : SovereignPalette.heatmapLightNavInactive;
    final active = isDark ? SovereignPalette.heatmapDarkMapActive : SovereignPalette.heatmapLightNavActive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border(top: BorderSide(color: border)),
        boxShadow: isDark
            ? const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.3),
                  blurRadius: 30,
                  offset: Offset(0, -8),
                ),
              ]
            : const [
                BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05),
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.grid_view_rounded,
                label: 'Home',
                color: inactive,
              ),
              _NavItem(
                icon: Icons.explore,
                label: 'Map',
                color: active,
                active: true,
              ),
              _NavItem(
                icon: Icons.description_outlined,
                label: 'Reports',
                color: inactive,
              ),
              _NavItem(
                icon: Icons.warning_amber_outlined,
                label: 'Alerts',
                color: inactive,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.color,
    this.active = false,
  });

  final IconData icon;
  final String label;
  final Color color;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 74,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
            size: active ? 30 : 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(
            height: 9,
            child: active
                ? Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
