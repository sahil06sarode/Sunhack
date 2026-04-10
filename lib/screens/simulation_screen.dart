import 'package:flutter/material.dart';

import 'package:conflictsense/screens/simulation_dark_screen.dart';
import 'package:conflictsense/screens/simulation_light_screen.dart';

class SimulationScreen extends StatelessWidget {
  const SimulationScreen({
    required this.useDark,
    super.key,
  });

  final bool useDark;

  @override
  Widget build(BuildContext context) {
    return useDark ? const SimulationDarkScreen() : const SimulationLightScreen();
  }
}
