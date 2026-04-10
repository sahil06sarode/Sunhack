import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/heatmap_bottom_nav.dart';
import 'package:conflictsense/widgets/heatmap_canvas.dart';
import 'package:conflictsense/widgets/heatmap_insight_card.dart';
import 'package:conflictsense/widgets/heatmap_top_bar.dart';

class HeatmapLightScreen extends StatelessWidget {
  const HeatmapLightScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.heatmapLightBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: const Column(
            children: [
              Expanded(
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: HeatmapCanvas(isDark: false),
                    ),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(24, 24, 24, 0),
                        child: HeatmapTopBar(isDark: false),
                      ),
                    ),
                    Positioned(
                      left: 24,
                      right: 24,
                      bottom: 24,
                      child: HeatmapInsightCard(isDark: false),
                    ),
                  ],
                ),
              ),
              HeatmapBottomNav(isDark: false),
            ],
          ),
        ),
      ),
    );
  }
}
