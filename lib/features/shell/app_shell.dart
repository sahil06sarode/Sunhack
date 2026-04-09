import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:conflictsense/features/auth/providers/auth_providers.dart';
import 'package:conflictsense/features/voice/presentation/voice_assistant_sheet.dart';

class AppShell extends ConsumerWidget {
  const AppShell({
    required this.currentLocation,
    required this.child,
    super.key,
  });

  final String currentLocation;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final authAction = ref.watch(authControllerProvider);
    final avatarSeed = (user?.displayName ?? user?.email ?? '').trim();
    final avatarInitial = avatarSeed.isEmpty
        ? '?'
        : avatarSeed.substring(0, 1).toUpperCase();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ConflictSense AI'),
        actions: [
          if (user != null)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    foregroundImage:
                        user.photoURL != null ? NetworkImage(user.photoURL!) : null,
                    child: user.photoURL == null ? Text(avatarInitial) : null,
                  ),
                  IconButton(
                    tooltip: 'Sign out',
                    onPressed: authAction.isLoading
                        ? null
                        : () async {
                            await ref.read(authControllerProvider.notifier).signOut();

                            if (!context.mounted) return;
                            final latest = ref.read(authControllerProvider);
                            if (latest.hasError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Sign out failed.')),
                              );
                            }
                          },
                    icon: const Icon(Icons.logout_rounded),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: child,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const VoiceAssistantSheet(),
          );
        },
        icon: const Icon(Icons.mic),
        label: const Text('Ask ConflictSense'),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indexForLocation(currentLocation),
        onDestinationSelected: (index) {
          context.go(_locationForIndex(index));
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.speed_rounded),
            label: 'Dashboard',
          ),
          NavigationDestination(
            icon: Icon(Icons.newspaper_rounded),
            label: 'Feed',
          ),
          NavigationDestination(
            icon: Icon(Icons.description_outlined),
            label: 'Report',
          ),
          NavigationDestination(
            icon: Icon(Icons.psychology_alt_outlined),
            label: 'Scenarios',
          ),
          NavigationDestination(
            icon: Icon(Icons.warning_amber_rounded),
            label: 'Alerts',
          ),
        ],
      ),
    );
  }

  int _indexForLocation(String location) {
    if (location.startsWith('/feed')) return 1;
    if (location.startsWith('/report')) return 2;
    if (location.startsWith('/scenarios')) return 3;
    if (location.startsWith('/alerts')) return 4;
    return 0;
  }

  String _locationForIndex(int index) {
    switch (index) {
      case 1:
        return '/feed';
      case 2:
        return '/report';
      case 3:
        return '/scenarios';
      case 4:
        return '/alerts';
      default:
        return '/dashboard';
    }
  }
}
