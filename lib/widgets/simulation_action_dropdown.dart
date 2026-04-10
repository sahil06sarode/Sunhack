import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SimulationActionDropdown extends StatelessWidget {
  const SimulationActionDropdown({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDark
        ? SovereignPalette.simulationDarkCard
        : SovereignPalette.simulationLightApp;
    final borderColor = isDark
        ? SovereignPalette.simulationDarkBorder
        : SovereignPalette.simulationLightBorder;
    final mutedText = isDark
        ? SovereignPalette.simulationDarkMuted
        : SovereignPalette.simulationLightMuted;
    final optionText =
        isDark ? SovereignPalette.simulationDarkText : SovereignPalette.simulationLightText;
    final dividerColor = isDark
        ? SovereignPalette.simulationDarkBorder.withValues(alpha: 0.55)
        : SovereignPalette.simulationLightBorder.withValues(alpha: 0.65);

    final options = <String>[
      'Increase military presence',
      'Economic sanctions',
      'Diplomatic shift',
    ];

    if (isDark) {
      return Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
        ),
        child: Column(
          children: [
            _DropdownHeader(
              isDark: true,
              textColor: mutedText,
              borderColor: dividerColor,
              backgroundColor: backgroundColor,
              showOuterBorder: false,
            ),
            ...List.generate(options.length, (index) {
              return _DropdownOption(
                text: options[index],
                textColor: optionText,
                backgroundColor: backgroundColor,
                borderColor: index < options.length - 1 ? dividerColor : null,
                textSize: 18,
              );
            }),
          ],
        ),
      );
    }

    return Column(
      children: [
        _DropdownHeader(
          isDark: false,
          textColor: mutedText,
          borderColor: borderColor,
          backgroundColor: backgroundColor,
          showOuterBorder: true,
        ),
        Container(
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(12)),
            border: Border(
              left: BorderSide(color: borderColor),
              right: BorderSide(color: borderColor),
              bottom: BorderSide(color: borderColor),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(15, 23, 42, 0.1),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: List.generate(options.length, (index) {
              return _DropdownOption(
                text: options[index],
                textColor: optionText,
                backgroundColor: index == 0
                    ? SovereignPalette.simulationLightMainTint
                    : SovereignPalette.simulationLightApp,
                borderColor: index < options.length - 1
                    ? SovereignPalette.simulationLightBorder.withValues(alpha: 0.5)
                    : null,
                textSize: 16,
                bottomRadius: index == options.length - 1 ? 12 : 0,
              );
            }),
          ),
        ),
      ],
    );
  }
}

class _DropdownHeader extends StatelessWidget {
  const _DropdownHeader({
    required this.isDark,
    required this.textColor,
    required this.borderColor,
    required this.backgroundColor,
    required this.showOuterBorder,
  });

  final bool isDark;
  final Color textColor;
  final Color borderColor;
  final Color backgroundColor;
  final bool showOuterBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        border: Border(
          left: showOuterBorder ? BorderSide(color: borderColor) : BorderSide.none,
          right: showOuterBorder ? BorderSide(color: borderColor) : BorderSide.none,
          top: showOuterBorder ? BorderSide(color: borderColor) : BorderSide.none,
          bottom: BorderSide(color: borderColor),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Select Action',
            style: TextStyle(
              color: textColor,
              fontSize: isDark ? 18 : 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          SvgPicture.string(
            _chevronDownSvg,
            width: 20,
            height: 20,
            colorFilter: ColorFilter.mode(textColor, BlendMode.srcIn),
          ),
        ],
      ),
    );
  }
}

class _DropdownOption extends StatelessWidget {
  const _DropdownOption({
    required this.text,
    required this.textColor,
    required this.backgroundColor,
    required this.textSize,
    this.borderColor,
    this.bottomRadius = 0,
  });

  final String text;
  final Color textColor;
  final Color backgroundColor;
  final Color? borderColor;
  final double textSize;
  final double bottomRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(bottomRadius)),
        border: Border(
          bottom: borderColor == null ? BorderSide.none : BorderSide(color: borderColor!),
        ),
      ),
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: textSize,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}

const String _chevronDownSvg = '''
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2">
  <path d="M19 9l-7 7-7-7"/>
</svg>
''';
