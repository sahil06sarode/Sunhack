import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/profile_bottom_nav.dart';
import 'package:conflictsense/widgets/profile_setting_row.dart';
import 'package:conflictsense/widgets/profile_top_bar.dart';

class ProfileDarkScreen extends StatelessWidget {
  const ProfileDarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.profileDarkBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 592),
          child: Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: Column(
                    children: [
                      const ColoredBox(
                        color: SovereignPalette.profileDarkHeaderBackground,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(24, 20, 24, 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ProfileTopBar(isDark: true),
                              SizedBox(height: 26),
                              Text(
                                'Officer Profile',
                                style: TextStyle(
                                  color: SovereignPalette.profileDarkSecondary,
                                  fontSize: 41 * 0.56,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Divider(height: 1, color: SovereignPalette.profileDarkBorder),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Officer J. Smith',
                                style: TextStyle(
                                  color: SovereignPalette.profileDarkText,
                                  fontSize: 53 * 0.62,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Senior Intelligence Analyst',
                                style: TextStyle(
                                  color: SovereignPalette.profileDarkSecondary,
                                  fontSize: 20 * 0.77,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              const Text(
                                'ID: 4920-A',
                                style: TextStyle(
                                  color: SovereignPalette.profileDarkTertiary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 26),
                              const ProfileSettingRow(
                                isDark: true,
                                title: 'Alert Preferences',
                                toggleOn: true,
                              ),
                              const SizedBox(height: 12),
                              const ProfileSettingRow(
                                isDark: true,
                                title: 'Theme',
                                trailingText: 'Light',
                                toggleOn: true,
                              ),
                              const SizedBox(height: 12),
                              const ProfileSettingRow(
                                isDark: true,
                                title: 'Favorite Regions',
                                trailingText: '3 Selected',
                                toggleOn: true,
                              ),
                              const Spacer(),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                decoration: BoxDecoration(
                                  color: SovereignPalette.profileDarkButton,
                                  borderRadius: BorderRadius.circular(20 * 0.75),
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
              const ProfileBottomNav(isDark: true),
            ],
          ),
        ),
      ),
    );
  }
}
