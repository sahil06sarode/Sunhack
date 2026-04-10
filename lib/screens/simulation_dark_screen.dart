import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/simulation_action_dropdown.dart';
import 'package:conflictsense/widgets/simulation_bottom_nav.dart';
import 'package:conflictsense/widgets/simulation_header.dart';
import 'package:conflictsense/widgets/simulation_prediction_card.dart';
import 'package:conflictsense/widgets/simulation_run_button.dart';
import 'package:conflictsense/widgets/simulation_what_if_field.dart';

class SimulationDarkScreen extends StatelessWidget {
  const SimulationDarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: SovereignPalette.simulationDarkBackground,
      body: Column(
        children: [
          SimulationHeader(isDark: true),
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
                      color: SovereignPalette.simulationDarkText,
                    ),
                  ),
                  SizedBox(height: 20),
                  SimulationWhatIfField(isDark: true),
                  SizedBox(height: 20),
                  SimulationActionDropdown(isDark: true),
                  SizedBox(height: 24),
                  SimulationPredictionCard(isDark: true),
                  SizedBox(height: 24),
                  SimulationRunButton(isDark: true),
                ],
              ),
            ),
          ),
          SimulationBottomNav(isDark: true),
        ],
      ),
    );
  }
}
