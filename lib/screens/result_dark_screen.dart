import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/result_bottom_nav.dart';
import 'package:conflictsense/widgets/result_bullet_list.dart';
import 'package:conflictsense/widgets/result_risk_badge.dart';
import 'package:conflictsense/widgets/result_sources_card.dart';

class ResultDarkScreen extends StatelessWidget {
  const ResultDarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: SovereignPalette.resultDarkBackground,
      body: Column(
        children: [
          Expanded(
            child: SafeArea(
              bottom: false,
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Intelligence Result',
                      style: TextStyle(
                        fontSize: 48 * 0.625,
                        fontWeight: FontWeight.w700,
                        color: SovereignPalette.resultDarkHeading,
                      ),
                    ),
                    SizedBox(height: 16),
                    Text(
                      'What is the risk level for Sudan?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: SovereignPalette.resultDarkHeading,
                      ),
                    ),
                    SizedBox(height: 14),
                    ResultRiskBadge(isDark: true),
                    SizedBox(height: 42),
                    Text(
                      'Sudan faces significant instability due to ongoing conflict between military factions, humanitarian crisis, and widespread displacement. International efforts are limited. Risk of escalation remains high.',
                      style: TextStyle(
                        fontSize: 17,
                        height: 1.62,
                        color: SovereignPalette.resultDarkBody,
                      ),
                    ),
                    SizedBox(height: 34),
                    ResultSourcesCard(isDark: true),
                    SizedBox(height: 34),
                    Text(
                      'Why this result?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: SovereignPalette.resultDarkHeading,
                      ),
                    ),
                    SizedBox(height: 14),
                    ResultBulletList(
                      isDark: true,
                      itemGap: 14,
                      fontSize: 17,
                      items: [
                        'Prolonged armed conflict in urban areas.',
                        'Severe humanitarian access restrictions.',
                        'Fragile ceasefire agreements.',
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          ResultBottomNav(isDark: true),
        ],
      ),
    );
  }
}
