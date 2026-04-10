import 'package:flutter/material.dart';

import 'package:conflictsense/screens/ai_research/ai_research_screen.dart';
import 'package:conflictsense/screens/feed_screen.dart';
import 'package:conflictsense/theme/app_visual_theme.dart';

class IntelligenceDashboard extends StatefulWidget {
  const IntelligenceDashboard({super.key});

  @override
  State<IntelligenceDashboard> createState() => _IntelligenceDashboardState();
}

class _IntelligenceDashboardState extends State<IntelligenceDashboard> {
  int _selectedTab = 0;
  final TextEditingController _searchController = TextEditingController();

  static const List<_AiPredictionData> _aiPredictions = [
    _AiPredictionData(
      interest: 'Conflict Forecasting',
      headline: 'Escalation probability is elevated for the next 48 hours',
      color: Color(0xFF2E6BCD),
      softColor: Color(0xFFEAF2FF),
      targetTopic: 'Conflict Forecasting Models',
      seedPrompt:
          'Analyze this prediction and explain key drivers: Escalation probability is elevated for the next 48 hours',
    ),
    _AiPredictionData(
      interest: 'Supply Chain Risk',
      headline: 'Maritime corridor disruption risk remains above baseline',
      color: Color(0xFF2E8D7B),
      softColor: Color(0xFFE8F8F4),
      targetTopic: 'Emerging Cybersecurity Threats',
      seedPrompt:
          'Break down supply-chain risk factors and mitigation options for maritime corridor disruption.',
    ),
    _AiPredictionData(
      interest: 'Diplomatic Stability',
      headline:
          'Ceasefire sentiment is improving with stronger diplomatic signals',
      color: Color(0xFFAF7B27),
      softColor: Color(0xFFFFF6E8),
      targetTopic: 'AI Governance and Safety',
      seedPrompt:
          'Evaluate diplomatic stability signals and propose next-step scenarios from the latest ceasefire momentum.',
    ),
  ];

  static const List<_TopicCardData> _topics = [
    _TopicCardData(
      icon: Icons.smart_toy_outlined,
      title: 'AI Tools',
      accent: Color(0xFF1C4C93),
      tint: Color(0xFFEAF2FF),
    ),
    _TopicCardData(
      icon: Icons.menu_book_outlined,
      title: 'Research Papers',
      accent: Color(0xFFB55D24),
      tint: Color(0xFFFFF2E7),
    ),
    _TopicCardData(
      icon: Icons.rocket_launch_outlined,
      title: 'Startups',
      accent: Color(0xFF1D8A79),
      tint: Color(0xFFE8F8F4),
    ),
    _TopicCardData(
      icon: Icons.trending_up_outlined,
      title: 'Technology Trends',
      accent: Color(0xFFD0574A),
      tint: Color(0xFFFFECE8),
    ),
  ];

  static const List<_BottomTabData> _tabs = [
    _BottomTabData(
      label: 'Home',
      icon: Icons.home_outlined,
      selectedIcon: Icons.home,
    ),
    _BottomTabData(
      label: 'Bookmark',
      icon: Icons.bookmark_border_rounded,
      selectedIcon: Icons.bookmark_rounded,
    ),
    _BottomTabData(
      label: 'AI Research',
      icon: Icons.psychology_alt_outlined,
      selectedIcon: Icons.psychology_alt_rounded,
    ),
    _BottomTabData(
      label: 'Trends',
      icon: Icons.local_fire_department_outlined,
      selectedIcon: Icons.local_fire_department_rounded,
    ),
    _BottomTabData(
      label: 'Profile',
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppVisualTheme.canvas,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppVisualTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              const _TopBar(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: _selectedTab == 0
                      ? _HomeTab(
                          key: const ValueKey('home'),
                          searchController: _searchController,
                          predictions: _aiPredictions,
                          onPredictionTap: _onPredictionTap,
                          topics: _topics,
                          onTopicTap: _onTopicTap,
                        )
                      : _SecondaryTabPlaceholder(
                          key: ValueKey(_tabs[_selectedTab].label),
                          title: _tabs[_selectedTab].label,
                          icon: _tabs[_selectedTab].selectedIcon,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            border: const Border(
              top: BorderSide(color: AppVisualTheme.cardStroke),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 14,
                offset: Offset(0, -3),
              ),
            ],
          ),
          child: Row(
            children: List.generate(
              _tabs.length,
              (index) => Expanded(
                child: _BottomNavItem(
                  data: _tabs[index],
                  isSelected: _selectedTab == index,
                  onTap: () => _onBottomNavTap(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == 2) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AIResearchScreen(),
        ),
      );
      return;
    }

    if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const FeedScreen(),
        ),
      );
      return;
    }

    setState(() {
      _selectedTab = index;
    });
  }

  void _onPredictionTap(_AiPredictionData prediction) {
    _searchController.text = prediction.headline;
    FocusScope.of(context).unfocus();

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AIResearchScreen(
          initialTopic: prediction.targetTopic,
          initialPrompt: prediction.seedPrompt,
        ),
      ),
    );
  }

  void _onTopicTap(String topic) {
    if (topic == 'AI Tools') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const AIResearchScreen(),
        ),
      );
      return;
    }

    if (topic == 'Technology Trends') {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => const FeedScreen(),
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening $topic'),
        duration: const Duration(milliseconds: 950),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppVisualTheme.cardStroke),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: const Row(
        children: [
          _AppLogo(),
          Spacer(),
          _ProfileAvatar(),
        ],
      ),
    );
  }
}

class _AppLogo extends StatelessWidget {
  const _AppLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppVisualTheme.brandBlue,
                AppVisualTheme.brandTeal,
              ],
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              const Icon(
                Icons.shield_rounded,
                size: 20,
                color: Colors.white,
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  width: 7,
                  height: 7,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFD56A),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'ConflictSense',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppVisualTheme.ink,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
        ),
      ],
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFC8D6F1),
        ),
      ),
      child: const Icon(
        Icons.person_rounded,
        color: AppVisualTheme.brandBlue,
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({
    required super.key,
    required this.searchController,
    required this.predictions,
    required this.onPredictionTap,
    required this.topics,
    required this.onTopicTap,
  });

  final TextEditingController searchController;
  final List<_AiPredictionData> predictions;
  final ValueChanged<_AiPredictionData> onPredictionTap;
  final List<_TopicCardData> topics;
  final ValueChanged<String> onTopicTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 22),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth:
                    constraints.maxWidth > 760 ? 760 : constraints.maxWidth,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const _HeroBanner(),
                  const SizedBox(height: 14),
                  _SearchSection(
                    searchController: searchController,
                  ),
                  const SizedBox(height: 16),
                  _AiPredictionSection(
                    predictions: predictions,
                    onPredictionTap: onPredictionTap,
                  ),
                  const SizedBox(height: 20),
                  _DiscoverSection(
                    topics: topics,
                    onTopicTap: onTopicTap,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SearchSection extends StatelessWidget {
  const _SearchSection({
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Search Intelligence',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppVisualTheme.ink,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: searchController,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Conflicts, diplomacy, supply chains, cyber threats...',
            prefixIcon: const Icon(Icons.search_rounded),
            fillColor: Colors.white.withValues(alpha: 0.95),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: AppVisualTheme.cardStroke),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(
                color: AppVisualTheme.brandBlue,
                width: 1.4,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AiPredictionSection extends StatelessWidget {
  const _AiPredictionSection({
    required this.predictions,
    required this.onPredictionTap,
  });

  final List<_AiPredictionData> predictions;
  final ValueChanged<_AiPredictionData> onPredictionTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'AI Prediction',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppVisualTheme.ink,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.2,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          'Recommended topics based on your predefined interests',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppVisualTheme.mutedInk,
                fontSize: 13,
              ),
        ),
        const SizedBox(height: 12),
        ...List.generate(
          predictions.length,
          (index) {
            final prediction = predictions[index];
            return Padding(
              padding: EdgeInsets.only(
                  bottom: index == predictions.length - 1 ? 0 : 10),
              child: _AiPredictionCard(
                data: prediction,
                onTap: () => onPredictionTap(prediction),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _AiPredictionCard extends StatelessWidget {
  const _AiPredictionCard({
    required this.data,
    required this.onTap,
  });

  final _AiPredictionData data;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
          decoration: BoxDecoration(
            color: data.softColor,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: data.color.withValues(alpha: 0.2)),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 5,
                height: 54,
                margin: const EdgeInsets.only(top: 2),
                decoration: BoxDecoration(
                  color: data.color,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.interest,
                      style: TextStyle(
                        color: data.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.35,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      data.headline,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppVisualTheme.ink,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Icon(
                Icons.chevron_right_rounded,
                color: data.color,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DiscoverSection extends StatelessWidget {
  const _DiscoverSection({
    required this.topics,
    required this.onTopicTap,
  });

  final List<_TopicCardData> topics;
  final ValueChanged<String> onTopicTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Discover',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppVisualTheme.ink,
                fontWeight: FontWeight.w800,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          'Explore curated tracks to stay ahead every day.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppVisualTheme.mutedInk,
                fontSize: 14,
              ),
        ),
        const SizedBox(height: 14),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 700;
            final crossAxisCount = isWide ? 4 : 2;
            final ratio = isWide ? 1.35 : 1.35;

            return GridView.builder(
              itemCount: topics.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: ratio,
              ),
              itemBuilder: (context, index) {
                final topic = topics[index];
                return _DiscoverTopicCard(
                  topic: topic,
                  onTap: () => onTopicTap(topic.title),
                );
              },
            );
          },
        ),
      ],
    );
  }
}

class _DiscoverTopicCard extends StatefulWidget {
  const _DiscoverTopicCard({
    required this.topic,
    required this.onTap,
  });

  final _TopicCardData topic;
  final VoidCallback onTap;

  @override
  State<_DiscoverTopicCard> createState() => _DiscoverTopicCardState();
}

class _DiscoverTopicCardState extends State<_DiscoverTopicCard> {
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.98 : 1.0;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: scale,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: widget.onTap,
            onTapDown: (_) => setState(() => _isPressed = true),
            onTapCancel: () => setState(() => _isPressed = false),
            onTapUp: (_) => setState(() => _isPressed = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: _isHovered
                    ? widget.topic.tint.withValues(alpha: 0.76)
                    : widget.topic.tint,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                    color: widget.topic.accent.withValues(alpha: 0.2)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: widget.topic.accent.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.topic.icon,
                      color: widget.topic.accent,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.topic.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppVisualTheme.ink,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
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
}

class _SecondaryTabPlaceholder extends StatelessWidget {
  const _SecondaryTabPlaceholder({
    required super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 460),
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.92),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppVisualTheme.cardStroke),
            boxShadow: const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 34, color: const Color(0xFF4D5360)),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF252A31),
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'This section is ready for your next feature module.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppVisualTheme.mutedInk,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.data,
    required this.isSelected,
    required this.onTap,
  });

  final _BottomTabData data;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color iconColor =
        isSelected ? AppVisualTheme.brandBlue : const Color(0xFF8B929E);
    final Color textColor =
        isSelected ? AppVisualTheme.brandBlue : const Color(0xFF8B929E);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 170),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppVisualTheme.brandBlue.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? data.selectedIcon : data.icon,
                size: 21,
                color: iconColor,
              ),
              const SizedBox(height: 4),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  data.label,
                  maxLines: 1,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    letterSpacing: 0.1,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BottomTabData {
  const _BottomTabData({
    required this.label,
    required this.icon,
    required this.selectedIcon,
  });

  final String label;
  final IconData icon;
  final IconData selectedIcon;
}

class _TopicCardData {
  const _TopicCardData({
    required this.icon,
    required this.title,
    required this.accent,
    required this.tint,
  });

  final IconData icon;
  final String title;
  final Color accent;
  final Color tint;
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1C4C93),
            Color(0xFF1E8D83),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x29000000),
            blurRadius: 20,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF95FFC9),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Live Overview',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.92),
                      letterSpacing: 0.45,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Today\'s Priority Signals',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 24,
                  height: 1.1,
                ),
          ),
          const SizedBox(height: 10),
          const Row(
            children: [
              _BannerIndicatorChip(
                icon: Icons.warning_amber_rounded,
                label: '3 High Priority',
              ),
              SizedBox(width: 8),
              _BannerIndicatorChip(
                icon: Icons.auto_graph_rounded,
                label: 'Updated 2m ago',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BannerIndicatorChip extends StatelessWidget {
  const _BannerIndicatorChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _AiPredictionData {
  const _AiPredictionData({
    required this.interest,
    required this.headline,
    required this.color,
    required this.softColor,
    required this.targetTopic,
    required this.seedPrompt,
  });

  final String interest;
  final String headline;
  final Color color;
  final Color softColor;
  final String targetTopic;
  final String seedPrompt;
}
