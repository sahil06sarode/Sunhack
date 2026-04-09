import 'package:flutter/material.dart';

import 'package:conflictsense/screens/home_dark_screen.dart';
import 'package:conflictsense/screens/home_light_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.useDark,
    super.key,
  });

  final bool useDark;

  @override
  Widget build(BuildContext context) {
    return useDark ? const HomeDarkScreen() : const HomeLightScreen();
  }
}
