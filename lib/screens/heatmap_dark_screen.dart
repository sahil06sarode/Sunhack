import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/heatmap_bottom_nav.dart';
import 'package:conflictsense/widgets/heatmap_canvas.dart';
import 'package:conflictsense/widgets/heatmap_insight_card.dart';
import 'package:conflictsense/widgets/heatmap_top_bar.dart';

class HeatmapDarkScreen extends StatelessWidget {
  const HeatmapDarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.heatmapDarkBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 592),
          child: const Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: HeatmapCanvas(isDark: true),
                    ),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24, 22, 24, 0),
                        child: HeatmapTopBar(isDark: true),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 18,
                      child: HeatmapInsightCard(isDark: true),
                    ),
                  ],
                ),
              ),
              HeatmapBottomNav(isDark: true),
            ],
          ),
        ),
      ),
    );
  }
}
