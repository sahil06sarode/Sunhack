import 'package:flutter/material.dart';

import 'package:conflictsense/screens/source_dark_screen.dart';
import 'package:conflictsense/screens/source_light_screen.dart';

class SourceScreen extends StatelessWidget {
  const SourceScreen({
    required this.useDark,
    super.key,
  });

  final bool useDark;

  @override
  Widget build(BuildContext context) {
    return useDark ? const SourceDarkScreen() : const SourceLightScreen();
  }
}
