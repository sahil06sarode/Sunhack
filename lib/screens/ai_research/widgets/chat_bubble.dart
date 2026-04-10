import 'package:flutter/material.dart';

import 'package:conflictsense/theme/app_visual_theme.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    required this.text,
    required this.isUser,
    super.key,
  });

  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isUser
            ? AppVisualTheme.brandBlue
            : Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(18),
        border: isUser ? null : Border.all(color: AppVisualTheme.cardStroke),
        boxShadow: isUser
            ? const []
            : const [
                BoxShadow(
                  color: Color(0x12000000),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isUser ? Colors.white : AppVisualTheme.ink,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          height: 1.45,
        ),
      ),
    );
  }
}
