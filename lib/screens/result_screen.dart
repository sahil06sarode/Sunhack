import 'package:flutter/material.dart';

import 'package:conflictsense/screens/result_dark_screen.dart';
import 'package:conflictsense/screens/result_light_screen.dart';

class ResultScreen extends StatelessWidget {
  const ResultScreen({
    required this.useDark,
    super.key,
  });

  final bool useDark;

  @override
  Widget build(BuildContext context) {
    return useDark ? const ResultDarkScreen() : const ResultLightScreen();
  }
}
