import 'package:flutter/material.dart';

import 'package:conflictsense/core/widgets/report_speaker_button.dart';
import 'package:conflictsense/screens/feed/models/feed_item.dart';

class FeedDetailPage extends StatelessWidget {
  const FeedDetailPage({
    required this.item,
    required this.heroTag,
    super.key,
  });

  final FeedItem item;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    final paragraphs = item.content
        .split('\n\n')
        .where((paragraph) => paragraph.trim().isNotEmpty)
        .toList();
    final speechText = [
      item.title,
      item.description,
      item.content,
    ].where((part) => part.trim().isNotEmpty).join('\n\n');

    return Scaffold(
      backgroundColor: const Color(0xFFF2F3F5),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            elevation: 0.4,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            expandedHeight: 290,
            leading: Padding(
              padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0x00000000).withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon:
                      const Icon(Icons.arrow_back_rounded, color: Colors.white),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 10, top: 8, bottom: 8),
                child: ReportSpeakerButton(
                  speechText: speechText,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Hero(
                    tag: heroTag,
                    child: Image.network(
                      item.image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, _, __) {
                        return Container(
                          color: const Color(0xFFDDE2EA),
                          alignment: Alignment.center,
                          child: const Icon(
                            Icons.image_not_supported_outlined,
                            size: 40,
                            color: Color(0xFF616875),
                          ),
                        );
                      },
                    ),
                  ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x22000000),
                          Color(0xA1000000),
                        ],
                      ),
                    ),
                  ),
                  if ((item.source ?? '').isNotEmpty ||
                      (item.timeAgo ?? '').isNotEmpty)
                    Positioned(
                      right: 16,
                      bottom: 14,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color:
                              const Color(0x00000000).withValues(alpha: 0.42),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          _metaText(item),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 28),
              child: Container(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x14000000),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: const TextStyle(
                        color: Color(0xFF1E232B),
                        fontSize: 28,
                        height: 1.2,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (item.description.trim().isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        item.description,
                        style: const TextStyle(
                          color: Color(0xFF4F5561),
                          fontSize: 15,
                          height: 1.45,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8ECF2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(
                          color: Color(0xFF343A44),
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Divider(height: 1, color: Color(0xFFE0E4EA)),
                    const SizedBox(height: 14),
                    ...paragraphs.map(
                      (paragraph) => Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Text(
                          paragraph,
                          style: const TextStyle(
                            color: Color(0xFF2C323B),
                            fontSize: 16,
                            height: 1.55,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
