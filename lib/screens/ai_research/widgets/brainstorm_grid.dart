import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_visual_theme.dart';

class BrainstormGrid extends StatelessWidget {
  const BrainstormGrid({
    required this.ideas,
    this.title,
    super.key,
  });

  final List<String> ideas;
  final String? title;

  @override
  Widget build(BuildContext context) {
    if (ideas.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppVisualTheme.cardStroke),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if ((title ?? '').isNotEmpty) ...[
            Text(
              title!,
              style: const TextStyle(
                color: AppVisualTheme.brandBlue,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
          ],
          GridView.builder(
            itemCount: ideas.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.55,
            ),
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF5FF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  ideas[index],
                  style: const TextStyle(
                    color: AppVisualTheme.ink,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
