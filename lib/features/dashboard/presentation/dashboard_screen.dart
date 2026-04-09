import 'package:flutter/material.dart';

import 'package:conflictsense/features/shared/presentation/minimal_screen_shell.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MinimalScreenShell(
      title: 'Dashboard',
      note: 'Design placeholder',
    );
  }
}
