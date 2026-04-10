import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_visual_theme.dart';

class PromptChips extends StatelessWidget {
  const PromptChips({
    required this.prompts,
    required this.onPromptTap,
    super.key,
  });

  final List<String> prompts;
  final ValueChanged<String> onPromptTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: prompts.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final prompt = prompts[index];
          return _PromptChip(
            label: prompt,
            onTap: () => onPromptTap(prompt),
          );
        },
      ),
    );
  }
}

class _PromptChip extends StatefulWidget {
  const _PromptChip({
    required this.label,
    required this.onTap,
  });

  final String label;
  final VoidCallback onTap;

  @override
  State<_PromptChip> createState() => _PromptChipState();
}

class _PromptChipState extends State<_PromptChip> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
            decoration: BoxDecoration(
              color: _isHovered
                  ? const Color(0xFFDDEBFF)
                  : const Color(0xFFEAF2FF),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFC8D8F6)),
            ),
            child: Text(
              widget.label,
              style: const TextStyle(
                color: AppVisualTheme.brandBlue,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
