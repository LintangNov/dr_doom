import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../data/models/user_profile.dart';

/// Provider to access the opened Isar database instance.
/// This must be overridden in the [ProviderScope] of the main application.
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar database instance has not been initialized.');
});

/// Helper function to asynchronously ensure that a default user profile (ID: 1)
/// exists in the database. Run in the background when the stream starts.
void _ensureDefaultProfileExists(Isar isar) async {
  try {
    final exists = await isar.userProfiles.get(1);
    if (exists == null) {
      final defaultProfile = UserProfile(
        id: 1,
        totalXp: 0,
        currentLevel: 1,
        currentStreak: 0,
        longestStreak: 0,
        lastActiveDate: DateTime.now(),
        unlockedBadgeIds: [],
        highRiskApps: [],
        isOnboardingCompleted: false,
        showPenaltyWarning: false,
        doomscrollingThresholdMinutes: 20,
        isMonitoringEnabled: true,
      );

      await isar.writeTxn(() async {
        await isar.userProfiles.put(defaultProfile);
      });
    }
  } catch (_) {
    // Silent catch for background initialization safety
  }
}

/// A re-active provider that streams the user's profile from the Isar database.
/// Instead of using complex async* generator timing, it returns the Isar stream
/// directly and triggers background profile initialization asynchronously.
final userProfileProvider = StreamProvider<UserProfile>((ref) {
  final isar = ref.watch(isarProvider);

  // Trigger background initialization of default profile if not exists
  _ensureDefaultProfileExists(isar);

  // Watch the user profile with ID 1 re-actively and fire immediately to prevent Riverpod StreamProvider infinite loading
  return isar.userProfiles.watchObject(1, fireImmediately: true).map((profile) {
    if (profile == null) {
      // Fallback fallback profile in case the database record is not written yet or deleted
      return UserProfile(
        id: 1,
        totalXp: 0,
        currentLevel: 1,
        currentStreak: 0,
        longestStreak: 0,
        lastActiveDate: DateTime.now(),
        unlockedBadgeIds: [],
        highRiskApps: [],
        isOnboardingCompleted: false,
        showPenaltyWarning: false,
        doomscrollingThresholdMinutes: 20,
        isMonitoringEnabled: true,
      );
    }
    return profile;
  });
});

/// Accessibility State Notifier to manually toggle High Contrast Mode
/// in addition to automatic system high contrast detection.
class HighContrastNotifier extends Notifier<bool> {
  @override
  bool build() => false;

  void toggle(bool value) {
    state = value;
  }
}

final highContrastProvider = NotifierProvider<HighContrastNotifier, bool>(() {
  return HighContrastNotifier();
});

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() => ThemeMode.system;

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }
}

final themeModeProvider = NotifierProvider<ThemeModeNotifier, ThemeMode>(() {
  return ThemeModeNotifier();
});
