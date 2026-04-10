import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_theme.dart';
import 'package:conflictsense/widgets/source_bottom_nav.dart';
import 'package:conflictsense/widgets/source_item_tile.dart';
import 'package:conflictsense/widgets/source_search_bar.dart';
import 'package:conflictsense/widgets/source_top_bar.dart';

class SourceLightScreen extends StatelessWidget {
  const SourceLightScreen({super.key});

  static const List<_SourceEntry> _sources = [
    _SourceEntry(title: 'Reuters Global', tag: 'High Credibility'),
    _SourceEntry(title: 'Sentinel Satellite Data', tag: 'Geospatial Intelligence'),
    _SourceEntry(title: 'International Crisis Group', tag: 'Policy Analysis'),
    _SourceEntry(title: 'Local Conflict Monitoring Network', tag: 'Ground Reporting'),
    _SourceEntry(title: 'OSINT Aggregator Pro', tag: 'Open-Source Intelligence'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SovereignPalette.sourceLightBackground,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 18, 24, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SourceTopBar(isDark: false),
                        const SizedBox(height: 26),
                        const Text(
                          'Intelligence Sources',
                          style: TextStyle(
                            color: SovereignPalette.sourceLightText,
                            fontSize: 34,
                            height: 1.1,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const SourceSearchBar(isDark: false),
                        const SizedBox(height: 6),
                        ...List.generate(_sources.length, (index) {
                          final item = _sources[index];
                          return SourceItemTile(
                            isDark: false,
                            title: item.title,
                            tag: item.tag,
                            isLast: index == _sources.length - 1,
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              const SourceBottomNav(isDark: false),
            ],
          ),
        ),
      ),
    );
  }
}

class _SourceEntry {
  const _SourceEntry({
    required this.title,
    required this.tag,
  });

  final String title;
  final String tag;
}
