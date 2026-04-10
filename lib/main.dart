import 'package:flutter/material.dart';

import 'package:conflictsense/screens/alerts_screen.dart';
import 'package:conflictsense/screens/heatmap_screen.dart';
import 'package:conflictsense/screens/home_screen.dart';
import 'package:conflictsense/screens/profile_screen.dart';
import 'package:conflictsense/screens/result_screen.dart';
import 'package:conflictsense/screens/source_screen.dart';
import 'package:conflictsense/screens/simulation_screen.dart';
import 'package:conflictsense/theme/app_theme.dart';

const bool _useDarkDesign = bool.fromEnvironment(
  'SOVEREIGN_DARK',
  defaultValue: false,
);

const String _designScreen = String.fromEnvironment(
  'SOVEREIGN_SCREEN',
  defaultValue: 'profile',
);

void main() {
  runApp(const SovereignApp());
}

class SovereignApp extends StatelessWidget {
  const SovereignApp({super.key});

  Widget get _homeScreen {
    final selectedScreen = _designScreen.toLowerCase();

    if (selectedScreen == 'home') {
      return const HomeScreen(useDark: _useDarkDesign);
    }

    if (selectedScreen == 'simulation') {
      return const SimulationScreen(useDark: _useDarkDesign);
    }

    if (selectedScreen == 'result') {
      return const ResultScreen(useDark: _useDarkDesign);
    }

    if (selectedScreen == 'alerts') {
      return const AlertsScreen(useDark: _useDarkDesign);
    }

    if (selectedScreen == 'heatmap') {
      return const HeatmapScreen(useDark: _useDarkDesign);
    }

    if (selectedScreen == 'source') {
      return const SourceScreen(useDark: _useDarkDesign);
    }

    return const ProfileScreen(useDark: _useDarkDesign);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sovereign Mobile App',
      debugShowCheckedModeBanner: false,
      theme: SovereignAppTheme.light,
      darkTheme: SovereignAppTheme.dark,
      themeMode: _useDarkDesign ? ThemeMode.dark : ThemeMode.light,
      home: _homeScreen,
    );
  }
}
