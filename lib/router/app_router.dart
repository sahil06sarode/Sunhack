import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:conflictsense/features/alerts/presentation/alerts_screen.dart';
import 'package:conflictsense/features/auth/presentation/login_screen.dart';
import 'package:conflictsense/features/auth/providers/auth_providers.dart';
import 'package:conflictsense/features/dashboard/presentation/dashboard_screen.dart';
import 'package:conflictsense/features/feed/presentation/feed_screen.dart';
import 'package:conflictsense/features/report/presentation/report_screen.dart';
import 'package:conflictsense/features/scenarios/presentation/scenarios_screen.dart';
import 'package:conflictsense/features/shell/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);
  final isAuthenticated = authState.valueOrNull != null;

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isLoggingIn = state.uri.path == '/login';

      if (authState.isLoading) {
        return null;
      }

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/dashboard';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(
          currentLocation: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/feed',
            builder: (context, state) => const FeedScreen(),
          ),
          GoRoute(
            path: '/report',
            builder: (context, state) => const ReportScreen(),
          ),
          GoRoute(
            path: '/scenarios',
            builder: (context, state) => const ScenariosScreen(),
          ),
          GoRoute(
            path: '/alerts',
            builder: (context, state) => const AlertsScreen(),
          ),
        ],
      ),
    ],
  );
});
