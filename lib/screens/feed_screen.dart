import 'package:flutter/material.dart';

import 'package:conflictsense/screens/ai_research/ai_research_screen.dart';
import 'package:conflictsense/screens/feed/data/mock_feed_data.dart';
import 'package:conflictsense/screens/feed/feed_detail_page.dart';
import 'package:conflictsense/screens/feed/models/feed_item.dart';
import 'package:conflictsense/screens/feed/widgets/category_chips.dart';
import 'package:conflictsense/screens/feed/widgets/feed_card.dart';
import 'package:conflictsense/screens/profile_screen.dart';
import 'package:conflictsense/theme/app_visual_theme.dart';

class LiveFeedScreen extends StatelessWidget {
  const LiveFeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeedScreen();
  }
}

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _activeCategory = 'AI';

  static const List<String> _categories = [
    'AI',
    'Technology',
    'Startups',
    'Research',
    'Finance',
    'Cybersecurity',
  ];

  static const List<_BottomTabData> _bottomTabs = [
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

  List<FeedItem> get _filteredItems {
    final query = _searchController.text;
    return mockFeedItems.where((item) {
      final matchesCategory = item.category == _activeCategory;
      return matchesCategory && item.matchesQuery(query);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_onSearchChanged)
      ..dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      return;
    }

    if (index == 2) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const AIResearchScreen(),
        ),
      );
      return;
    }

    if (index == 3) {
      return;
    }

    if (index == 4) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const UserProfileScreen(),
        ),
      );
      return;
    }

    final label = _bottomTabs[index].label;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$label section is coming soon.'),
        duration: const Duration(milliseconds: 900),
      ),
    );
  }

  void _openDetails(FeedItem item, int index) {
    final heroTag = 'feed-card-image-$index-${item.title.hashCode}';
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        transitionDuration: const Duration(milliseconds: 280),
        reverseTransitionDuration: const Duration(milliseconds: 220),
        pageBuilder: (context, animation, secondaryAnimation) {
          final curved =
              CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: FeedDetailPage(
              item: item,
              heroTag: heroTag,
            ),
          );
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final slide = Tween<Offset>(
            begin: const Offset(0, 0.03),
            end: Offset.zero,
          ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));
          return SlideTransition(
            position: slide,
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredItems = _filteredItems;

    return Scaffold(
      backgroundColor: AppVisualTheme.canvas,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppVisualTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              const _FeedHeading(),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: _SearchBar(controller: _searchController),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
                child: CategoryChips(
                  categories: _categories,
                  activeCategory: _activeCategory,
                  onCategorySelected: (selected) {
                    setState(() {
                      _activeCategory = selected;
                    });
                  },
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: filteredItems.isEmpty
                    ? _EmptyFeedState(
                        activeCategory: _activeCategory,
                        searchText: _searchController.text,
                      )
                    : ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                        itemCount: filteredItems.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = filteredItems[index];
                          return FeedCard(
                            item: item,
                            heroTag:
                                'feed-card-image-$index-${item.title.hashCode}',
                            onTap: () => _openDetails(item, index),
                          );
                        },
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
              _bottomTabs.length,
              (index) => Expanded(
                child: _BottomNavItem(
                  data: _bottomTabs[index],
                  isSelected: index == 3,
                  onTap: () => _onBottomNavTap(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FeedHeading extends StatelessWidget {
  const _FeedHeading();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 16, 16, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Signal Feed',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: AppVisualTheme.ink,
                    fontSize: 36,
                    letterSpacing: -0.6,
                  ),
            ),
            const SizedBox(height: 2),
            Text(
              'Color-coded updates from AI, research, markets, and security.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppVisualTheme.mutedInk,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
  });

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Search news, research, trends...',
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

class _EmptyFeedState extends StatelessWidget {
  const _EmptyFeedState({
    required this.activeCategory,
    required this.searchText,
  });

  final String activeCategory;
  final String searchText;

  @override
  Widget build(BuildContext context) {
    final hasSearchText = searchText.trim().isNotEmpty;
    final message = hasSearchText
        ? 'No matches found in $activeCategory for "$searchText".'
        : 'No feed items are available in $activeCategory right now.';

    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppVisualTheme.cardStroke),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.newspaper_outlined,
              size: 36,
              color: Color(0xFF545B67),
            ),
            const SizedBox(height: 10),
            const Text(
              'No Stories Yet',
              style: TextStyle(
                color: Color(0xFF2A3038),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6D7480),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
