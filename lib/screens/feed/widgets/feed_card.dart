import 'package:flutter/material.dart';

import 'package:conflictsense/screens/feed/models/feed_item.dart';
import 'package:conflictsense/theme/app_visual_theme.dart';

class FeedCard extends StatefulWidget {
  const FeedCard({
    super.key,
    required this.item,
    required this.heroTag,
    required this.onTap,
  });

  final FeedItem item;
  final String heroTag;
  final VoidCallback onTap;

  @override
  State<FeedCard> createState() => _FeedCardState();
}

class _FeedCardState extends State<FeedCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.985 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) {
        setState(() {
          _isHovered = false;
          _isPressed = false;
        });
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        scale: scale,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapCancel: () => setState(() => _isPressed = false),
            onTapUp: (_) => setState(() => _isPressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: _isHovered
                    ? const Color(0xFFF4F8FF)
                    : Colors.white.withValues(alpha: 0.95),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppVisualTheme.cardStroke),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x16000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Hero(
                        tag: widget.heroTag,
                        child: Image.network(
                          widget.item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, _, __) {
                            return Container(
                              color: const Color(0xFFDDE2EA),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.image_not_supported_outlined,
                                color: Color(0xFF616875),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color:
                                AppVisualTheme.brandBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            widget.item.category,
                            style: const TextStyle(
                              color: AppVisualTheme.brandBlue,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.item.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppVisualTheme.ink,
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        if (widget.item.description.trim().isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            widget.item.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: AppVisualTheme.mutedInk,
                              fontSize: 13,
                              height: 1.35,
                            ),
                          ),
                        ],
                        if ((widget.item.source ?? '').isNotEmpty ||
                            (widget.item.timeAgo ?? '').isNotEmpty) ...[
                          const SizedBox(height: 10),
                          Text(
                            _metaText(widget.item),
                            style: const TextStyle(
                              color: Color(0xFF8A919E),
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _metaText(FeedItem item) {
    final source = item.source ?? '';
    final timeAgo = item.timeAgo ?? '';

    if (source.isNotEmpty && timeAgo.isNotEmpty) {
      return '$source  •  $timeAgo';
    }
    return source.isNotEmpty ? source : timeAgo;
  }
}
