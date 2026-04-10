import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/profile_bottom_nav.dart';
import 'package:conflictsense/widgets/profile_setting_row.dart';
import 'package:conflictsense/widgets/profile_top_bar.dart';

class ProfileLightScreen extends StatelessWidget {
  const ProfileLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.profileLightBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProfileTopBar(isDark: false),
                            SizedBox(height: 26),
                            Text(
                              'Officer Profile',
                              style: TextStyle(
                                color: SovereignPalette.profileLightText,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 1, color: SovereignPalette.profileLightBorder),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Officer J. Smith',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 53 * 0.62,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Senior Intelligence Analyst',
                                style: TextStyle(
                                  color: SovereignPalette.profileLightSecondary,
                                  fontSize: 20 * 0.77,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'ID: 4920-A',
                                style: TextStyle(
                                  color: SovereignPalette.profileLightSecondary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 30),
                              const ProfileSettingRow(
                                isDark: false,
                                title: 'Alert Preferences',
                                toggleOn: true,
                              ),
                              const ProfileSettingRow(
                                isDark: false,
                                title: 'Theme',
                                trailingText: 'Light',
                                toggleOn: false,
                              ),
                              const ProfileSettingRow(
                                isDark: false,
                                title: 'Favorite Regions',
                                trailingText: '3 Selected',
                                toggleOn: true,
                              ),
                              const Spacer(),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: SovereignPalette.profileLightButton,
                                  borderRadius: BorderRadius.circular(14 * 0.75),
                                ),
                                child: const Text(
                                  'Log Out',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 42 * 0.58,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 18),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const ProfileBottomNav(isDark: false),
            ],
          ),
        ),
      ),
    );
  }
}
