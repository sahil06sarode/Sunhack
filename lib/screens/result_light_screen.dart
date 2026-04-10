import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/result_bottom_nav.dart';
import 'package:conflictsense/widgets/result_bullet_list.dart';
import 'package:conflictsense/widgets/result_risk_badge.dart';
import 'package:conflictsense/widgets/result_sources_card.dart';

class ResultLightScreen extends StatelessWidget {
  const ResultLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.resultLightFrame,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 400),
          child: const DecoratedBox(
            decoration: BoxDecoration(
              color: SovereignPalette.resultLightSurface,
              boxShadow: [
                BoxShadow(
                  color: Color.fromRGBO(15, 23, 42, 0.12),
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
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
                              color: SovereignPalette.resultLightHeading,
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'What is the risk level for Sudan?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: SovereignPalette.resultLightHeading,
                            ),
                          ),
                          SizedBox(height: 14),
                          ResultRiskBadge(isDark: false),
                          SizedBox(height: 42),
                          Text(
                            'Sudan faces significant instability due to ongoing conflict between military factions, humanitarian crisis, and widespread displacement. International efforts are limited. Risk of escalation remains high.',
                            style: TextStyle(
                              fontSize: 17,
                              height: 1.6,
                              color: SovereignPalette.resultLightBody,
                            ),
                          ),
                          SizedBox(height: 34),
                          ResultSourcesCard(isDark: false),
                          SizedBox(height: 34),
                          Text(
                            'Why this result?',
                            style: TextStyle(
                              fontSize: 42 * 0.45,
                              fontWeight: FontWeight.w700,
                              color: SovereignPalette.resultLightHeading,
                            ),
                          ),
                          SizedBox(height: 14),
                          ResultBulletList(
                            isDark: false,
                            itemGap: 12,
                            fontSize: 16,
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
                ResultBottomNav(isDark: false),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
