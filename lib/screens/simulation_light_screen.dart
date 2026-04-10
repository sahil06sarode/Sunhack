import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/simulation_action_dropdown.dart';
import 'package:conflictsense/widgets/simulation_bottom_nav.dart';
import 'package:conflictsense/widgets/simulation_header.dart';
import 'package:conflictsense/widgets/simulation_prediction_card.dart';
import 'package:conflictsense/widgets/simulation_run_button.dart';
import 'package:conflictsense/widgets/simulation_what_if_field.dart';

class SimulationLightScreen extends StatelessWidget {
  const SimulationLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.simulationLightFrame,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 414),
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: SovereignPalette.simulationLightApp,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(15, 23, 42, 0.12),
                  blurRadius: 20,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              children: [
                SimulationHeader(isDark: false),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(24, 32, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Simulation',
                          style: TextStyle(
                            fontSize: 30,
                            height: 1.2,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF111827),
                          ),
                        ),
                        SizedBox(height: 32),
                        SimulationWhatIfField(isDark: false),
                        SizedBox(height: 16),
                        SimulationActionDropdown(isDark: false),
                        SizedBox(height: 24),
                        SimulationPredictionCard(isDark: false),
                        SizedBox(height: 24),
                        SimulationRunButton(isDark: false),
                      ],
                    ),
                  ),
                ),
                SimulationBottomNav(isDark: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
