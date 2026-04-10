import 'package:flutter/material.dart';

import 'package:conflictsense/screens/heatmap_dark_screen.dart';
import 'package:conflictsense/screens/heatmap_light_screen.dart';

class HeatmapScreen extends StatelessWidget {
  const HeatmapScreen({
    required this.useDark,
    super.key,
  });

  final bool useDark;

  @override
  Widget build(BuildContext context) {
    return useDark ? const HeatmapDarkScreen() : const HeatmapLightScreen();
  }
}
