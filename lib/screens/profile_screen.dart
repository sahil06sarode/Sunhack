import 'package:flutter/material.dart';

import 'package:conflictsense/screens/profile_dark_screen.dart';
import 'package:conflictsense/screens/profile_light_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.useDark,
    super.key,
  });

  final bool useDark;

  @override
  Widget build(BuildContext context) {
    return useDark ? const ProfileDarkScreen() : const ProfileLightScreen();
  }
}
