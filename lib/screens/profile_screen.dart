import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:conflictsense/screens/ai_research/ai_research_screen.dart';
import 'package:conflictsense/screens/feed_screen.dart';
import 'package:conflictsense/theme/app_visual_theme.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  bool _isSigningOut = false;

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

  User? get _user => FirebaseAuth.instance.currentUser;

  Future<void> _signOut() async {
    if (_isSigningOut) {
      return;
    }

    setState(() {
      _isSigningOut = true;
    });

    try {
      await FirebaseAuth.instance.signOut();
      if (!mounted) {
        return;
      }

      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (error) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign out failed: $error'),
          duration: const Duration(milliseconds: 1200),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSigningOut = false;
        });
      }
    }
  }

  void _onBottomNavTap(int index) {
    if (index == 0) {
      Navigator.of(context).popUntil((route) => route.isFirst);
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
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => const FeedScreen(),
        ),
      );
      return;
    }

    if (index == 4) {
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

  @override
  Widget build(BuildContext context) {
    final user = _user;

    if (user == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'You are not signed in.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppVisualTheme.canvas,
      body: DecoratedBox(
        decoration: const BoxDecoration(gradient: AppVisualTheme.pageGradient),
        child: SafeArea(
          child: Column(
            children: [
              const _ProfileTopBar(),
              Expanded(
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            'Could not load profile right now. Please try again.',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppVisualTheme.mutedInk,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }

                    final data =
                        snapshot.data?.data() ?? const <String, dynamic>{};

                    return _ProfileBody(
                      user: user,
                      data: data,
                      isSigningOut: _isSigningOut,
                      onSignOutTap: _signOut,
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
                  isSelected: index == 4,
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

class _ProfileTopBar extends StatelessWidget {
  const _ProfileTopBar();

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
      child: SizedBox(
        height: 40,
        child: Stack(
          alignment: Alignment.center,
          children: [
            const Row(
              children: [
                _AppLogo(),
                Spacer(),
                _ProfileIcon(),
              ],
            ),
            Text(
              'Profile',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppVisualTheme.ink,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
            ),
          ],
        ),
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
          child: const Icon(
            Icons.hub_rounded,
            size: 19,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          'IntelNova',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppVisualTheme.ink,
                fontWeight: FontWeight.w800,
              ),
        ),
      ],
    );
  }
}

class _ProfileIcon extends StatelessWidget {
  const _ProfileIcon();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFEAF0FF),
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFC8D6F1)),
      ),
      child: const Icon(
        Icons.manage_accounts_rounded,
        color: AppVisualTheme.brandBlue,
      ),
    );
  }
}

class _ProfileBody extends StatelessWidget {
  const _ProfileBody({
    required this.user,
    required this.data,
    required this.isSigningOut,
    required this.onSignOutTap,
  });

  final User user;
  final Map<String, dynamic> data;
  final bool isSigningOut;
  final VoidCallback onSignOutTap;

  @override
  Widget build(BuildContext context) {
    final displayName = _resolveDisplayName(user, data);
    final email = (user.email ?? data['email'] as String? ?? 'No email').trim();
    final role = _readString(data['role'], fallback: 'Analyst');
    final alertSensitivity =
        _readString(data['alertSensitivity'], fallback: 'Medium');
    final regions = _readList(data['regions']);
    final topics = _readList(data['topics']);
    final joinedOn = _readJoinedDate(data['createdAt']);
    final initials = _createInitials(displayName, email);

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth =
            constraints.maxWidth > 760 ? 760.0 : constraints.maxWidth;

        return Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
              children: [
                _ProfileHero(
                  displayName: displayName,
                  email: email,
                  role: role,
                  alertSensitivity: alertSensitivity,
                  initials: initials,
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  title: 'Account',
                  child: Column(
                    children: [
                      _InfoTile(
                        icon: Icons.person_rounded,
                        label: 'Display Name',
                        value: displayName,
                      ),
                      _InfoTile(
                        icon: Icons.email_rounded,
                        label: 'Email',
                        value: email,
                      ),
                      _InfoTile(
                        icon: Icons.calendar_month_rounded,
                        label: 'Member Since',
                        value: joinedOn,
                      ),
                      _InfoTile(
                        icon: Icons.badge_rounded,
                        label: 'User ID',
                        value: user.uid,
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  title: 'Intelligence Preferences',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PreferenceGroup(
                        heading: 'Regions',
                        values: regions,
                        emptyState: 'No regions selected yet.',
                      ),
                      const SizedBox(height: 14),
                      _PreferenceGroup(
                        heading: 'Threat Topics',
                        values: topics,
                        emptyState: 'No topics selected yet.',
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                _SectionCard(
                  title: 'Session',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      OutlinedButton.icon(
                        onPressed: isSigningOut ? null : onSignOutTap,
                        icon: isSigningOut
                            ? const SizedBox(
                                height: 14,
                                width: 14,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Icon(Icons.logout_rounded),
                        label: Text(
                          isSigningOut ? 'Signing out...' : 'Sign out securely',
                        ),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppVisualTheme.cardStroke),
                          foregroundColor: AppVisualTheme.ink,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _resolveDisplayName(User user, Map<String, dynamic> data) {
    final firestoreName = _readString(data['name']);
    if (firestoreName.isNotEmpty) {
      return firestoreName;
    }

    final authName = _readString(user.displayName);
    if (authName.isNotEmpty) {
      return authName;
    }

    return 'IntelNova User';
  }

  static String _readString(Object? value, {String fallback = ''}) {
    if (value is String) {
      final trimmed = value.trim();
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return fallback;
  }

  static List<String> _readList(Object? value) {
    if (value is List) {
      return value
          .whereType<String>()
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList();
    }

    return const <String>[];
  }

  static String _createInitials(String name, String email) {
    final words = name
        .split(' ')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();

    if (words.length >= 2) {
      return '${words.first[0]}${words[1][0]}'.toUpperCase();
    }

    if (words.isNotEmpty) {
      return words.first[0].toUpperCase();
    }

    if (email.isNotEmpty) {
      return email[0].toUpperCase();
    }

    return 'U';
  }

  static String _readJoinedDate(Object? value) {
    if (value is Timestamp) {
      final date = value.toDate();
      return '${date.day.toString().padLeft(2, '0')} ${_monthName(date.month)} ${date.year}';
    }

    return 'Recently joined';
  }

  static String _monthName(int month) {
    const months = <String>[
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    if (month < 1 || month > 12) {
      return 'Unknown';
    }

    return months[month - 1];
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero({
    required this.displayName,
    required this.email,
    required this.role,
    required this.alertSensitivity,
    required this.initials,
  });

  final String displayName;
  final String email;
  final String role;
  final String alertSensitivity;
  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1C4C93),
            Color(0xFF1D8A79),
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
                width: 54,
                height: 54,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Text(
                  initials,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      displayName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroChip(
                icon: Icons.work_outline_rounded,
                label: role,
              ),
              _HeroChip(
                icon: Icons.notifications_active_outlined,
                label: alertSensitivity,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.24)),
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

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppVisualTheme.ink,
                  fontWeight: FontWeight.w800,
                ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: isLast ? 0 : 10),
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F9FD),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE0E7F2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFE9F0FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              size: 16,
              color: AppVisualTheme.brandBlue,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppVisualTheme.mutedInk,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppVisualTheme.ink,
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferenceGroup extends StatelessWidget {
  const _PreferenceGroup({
    required this.heading,
    required this.values,
    required this.emptyState,
  });

  final String heading;
  final List<String> values;
  final String emptyState;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          heading,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppVisualTheme.mutedInk,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
        ),
        const SizedBox(height: 8),
        if (values.isEmpty)
          Text(
            emptyState,
            style: Theme.of(context).textTheme.bodyMedium,
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: values
                .map(
                  (value) => Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF2FF),
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(color: const Color(0xFFD1DFF5)),
                    ),
                    child: Text(
                      value,
                      style: const TextStyle(
                        color: AppVisualTheme.brandBlue,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
      ],
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
