import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class ProfileBottomNav extends StatelessWidget {
  const ProfileBottomNav({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final background = isDark
        ? SovereignPalette.profileDarkNavBackground
        : SovereignPalette.profileLightBackground;
    final border = isDark
        ? SovereignPalette.profileDarkBorder
        : SovereignPalette.profileLightBorder;
    final active = isDark
        ? SovereignPalette.profileDarkNavActive
        : SovereignPalette.profileLightNavActive;
    final inactive = isDark
        ? SovereignPalette.profileDarkNavInactive
        : SovereignPalette.profileLightNavInactive;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border(top: BorderSide(color: border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 10, 18, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _NavItem(
                    icon: Icons.grid_view,
                    label: 'Home',
                    color: active,
                    active: true,
                  ),
                  _NavItem(
                    icon: Icons.location_on,
                    label: 'Map',
                    color: inactive,
                  ),
                  _NavItem(
                    icon: Icons.description,
                    label: 'Reports',
                    color: inactive,
                  ),
                  _NavItem(
                    icon: Icons.warning,
                    label: 'Alerts',
                    color: inactive,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: isDark ? 138 : 130,
                height: 6,
                decoration: BoxDecoration(
                  color: isDark ? Colors.white.withValues(alpha: 0.7) : Colors.black,
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
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
