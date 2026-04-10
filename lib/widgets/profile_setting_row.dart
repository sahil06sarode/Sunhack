import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class ProfileSettingRow extends StatelessWidget {
  const ProfileSettingRow({
    required this.isDark,
    required this.title,
    this.trailingText,
    required this.toggleOn,
    super.key,
  });

  final bool isDark;
  final String title;
  final String? trailingText;
  final bool toggleOn;

  @override
  Widget build(BuildContext context) {
    final titleColor = isDark ? SovereignPalette.profileDarkText : SovereignPalette.profileLightText;
    final trailingColor = isDark ? SovereignPalette.profileDarkTertiary : SovereignPalette.profileLightSecondary;
    final borderColor = isDark
        ? Colors.transparent
        : SovereignPalette.profileLightBorder.withValues(alpha: 0.6);

    final rowContent = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor,
              fontSize: isDark ? 46 * 0.55 : 15,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        if (trailingText != null) ...[
          Text(
            trailingText!,
            style: TextStyle(
              color: trailingColor,
              fontSize: isDark ? 17 : 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 14),
        ],
        _StaticSwitch(
          isDark: isDark,
          isOn: toggleOn,
        ),
      ],
    );

    if (isDark) {
      return Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
        decoration: BoxDecoration(
          color: SovereignPalette.profileDarkCard,
          borderRadius: BorderRadius.circular(22),
        ),
        child: rowContent,
      );
    }

    return Container(
      padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: rowContent,
    );
  }
}

class _StaticSwitch extends StatelessWidget {
  const _StaticSwitch({
    required this.isDark,
    required this.isOn,
  });

  final bool isDark;
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    final background = isDark
        ? SovereignPalette.profileDarkToggle
        : (isOn ? SovereignPalette.profileLightToggleOn : SovereignPalette.profileLightToggleOff);

    return Container(
      width: 52,
      height: 32,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Align(
        alignment: Alignment.centerRight,
        child: Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
