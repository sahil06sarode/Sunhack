import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SimulationWhatIfField extends StatelessWidget {
  const SimulationWhatIfField({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isDark ? SovereignPalette.simulationDarkCard : SovereignPalette.simulationLightApp;
    final borderColor =
        isDark ? SovereignPalette.simulationDarkBorder : SovereignPalette.simulationLightBorder;
    final textColor =
        isDark ? SovereignPalette.simulationDarkText : SovereignPalette.simulationLightText;
    final hintColor =
        isDark ? SovereignPalette.simulationDarkMuted : SovereignPalette.simulationLightMutedSoft;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
        boxShadow: isDark
            ? const []
            : const [
                BoxShadow(
                  color: Color.fromRGBO(15, 23, 42, 0.04),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
      ),
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: 'What ',
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
            TextSpan(
              text: 'if...',
              style: TextStyle(
                color: hintColor,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
