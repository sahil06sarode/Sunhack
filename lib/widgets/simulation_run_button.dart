import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';

class SimulationRunButton extends StatelessWidget {
  const SimulationRunButton({
    required this.isDark,
    super.key,
  });

  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final backgroundColor =
        isDark ? SovereignPalette.simulationDarkCard : SovereignPalette.simulationLightButton;
    final borderColor = isDark
        ? SovereignPalette.simulationDarkBorder.withValues(alpha: 0.8)
        : SovereignPalette.simulationLightButton;

    return SizedBox(
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor),
          boxShadow: isDark
              ? const []
              : const [
                  BoxShadow(
                    color: Color.fromRGBO(15, 23, 42, 0.16),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Run Simulation',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
