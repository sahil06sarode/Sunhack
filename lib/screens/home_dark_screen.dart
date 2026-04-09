import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/ask_question_bar.dart';
import 'package:conflictsense/widgets/info_card_panel.dart';
import 'package:conflictsense/widgets/sovereign_bottom_nav.dart';
import 'package:conflictsense/widgets/sovereign_header.dart';

class HomeDarkScreen extends StatelessWidget {
  const HomeDarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.darkBackground,
      body: Column(
        children: [
          const SovereignHeader(isDark: true),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 448),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AskQuestionBar(isDark: true),
                      SizedBox(height: 24),
                      InfoCardPanel(
                        title: 'Recent Risk',
                        message: 'Increased frequency of non-standard in sector 4B.',
                        isDark: true,
                      ),
                      SizedBox(height: 24),
                      InfoCardPanel(
                        title: 'Live Alert',
                        message: 'Live alerts suggests shift in critical tect1 info.',
                        isDark: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const SovereignBottomNav(isDark: true),
    );
  }
}
