import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:isar_community/isar.dart';
import '../presentation/screens/onboarding/onboarding_screen.dart';
import '../presentation/screens/dashboard/dashboard_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';
import '../providers/database_provider.dart';
import '../data/models/user_profile.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final isar = ref.watch(isarProvider);

  return GoRouter(
    initialLocation: '/onboarding',
    redirect: (context, state) {
      try {
        final profile = isar.userProfiles.getSync(1);
        final isOnboarding = state.uri.path == '/onboarding';

        if (profile != null && profile.isOnboardingCompleted) {
          if (isOnboarding) {
            return '/dashboard'; // Redirect to dashboard if onboarding is completed!
          }
        } else {
          if (!isOnboarding) {
            return '/onboarding'; // Force onboarding if not completed!
          }
        }
      } catch (_) {
        // Safe catch during database startup or testing
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('No route defined for ${state.uri}'),
      ),
    ),
  );
});
