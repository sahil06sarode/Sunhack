import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/ask_question_bar.dart';
import 'package:conflictsense/widgets/info_card_panel.dart';
import 'package:conflictsense/widgets/sovereign_bottom_nav.dart';
import 'package:conflictsense/widgets/sovereign_header.dart';

class HomeLightScreen extends StatelessWidget {
  const HomeLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.lightBackground,
      body: Column(
        children: [
          const SovereignHeader(isDark: false),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 448),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: 40),
                        AskQuestionBar(isDark: false),
                        SizedBox(height: 48),
                        InfoCardPanel(
                          title: 'Recent Risk',
                          message: 'Increased frequency of non-standard in sector 4B.',
                          isDark: false,
                        ),
                        SizedBox(height: 20),
                        InfoCardPanel(
                          title: 'Live Alert',
                          message: 'Live alerts suggests shift in critical tect1 info.',
                          isDark: false,
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SovereignBottomNav(isDark: false),
    );
  }
}
