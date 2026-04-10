import 'package:flutter/material.dart';

import 'package:conflictsense/screens/alerts_dark_screen.dart';
import 'package:conflictsense/screens/alerts_light_screen.dart';

class AlertsScreen extends StatelessWidget {
  const AlertsScreen({
    required this.useDark,
    super.key,
  });

  final bool useDark;

  @override
  Widget build(BuildContext context) {
    return useDark ? const AlertsDarkScreen() : const AlertsLightScreen();
  }
}
