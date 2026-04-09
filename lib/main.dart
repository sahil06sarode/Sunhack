import 'package:flutter/material.dart';

import 'package:conflictsense/screens/home_screen.dart';
import 'package:conflictsense/theme/app_theme.dart';

const bool _useDarkDesign = bool.fromEnvironment(
  'SOVEREIGN_DARK',
  defaultValue: false,
);

void main() {
  runApp(const SovereignApp());
}

class SovereignApp extends StatelessWidget {
  const SovereignApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sovereign Mobile App',
      debugShowCheckedModeBanner: false,
      theme: SovereignAppTheme.light,
      darkTheme: SovereignAppTheme.dark,
      themeMode: _useDarkDesign ? ThemeMode.dark : ThemeMode.light,
      home: const HomeScreen(useDark: _useDarkDesign),
    );
  }
}
