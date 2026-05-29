import '../../../data/models/user_profile.dart';

class AchievementChecker {
  const AchievementChecker();

  // Badge Constant IDs
  static const String badgeBenihKesadaran = 'benih_kesadaran';
  static const String badgeQuickRecover = 'quick_recover';

  /// Checks if the user is eligible for new badges and unlocks them in the profile.
  /// Returns a list of newly unlocked badge IDs for UI notification triggers.
  List<String> checkNewBadges(
    UserProfile profile, {
    required int totalCognitiveBumpsCompleted,
    required double initialDrs,
    required double finalDrs,
  }) {
    final List<String> newlyUnlocked = [];

    // 1. "Benih Kesadaran": Selesaikan bump pertama kali
    if (totalCognitiveBumpsCompleted >= 1 &&
        !profile.unlockedBadgeIds.contains(badgeBenihKesadaran)) {
      newlyUnlocked.add(badgeBenihKesadaran);
    }

    // 2. "Quick Recover": DRS turun dari 80+ ke <30 dalam satu sesi
    if (initialDrs >= 80.0 &&
        finalDrs < 30.0 &&
        !profile.unlockedBadgeIds.contains(badgeQuickRecover)) {
      newlyUnlocked.add(badgeQuickRecover);
    }

    // If new badges were unlocked, append them to the profile list
    if (newlyUnlocked.isNotEmpty) {
      // Create a new list to avoid side effects or modify directly since it is mutable
      final updatedBadges = List<String>.from(profile.unlockedBadgeIds)
        ..addAll(newlyUnlocked);
      profile.unlockedBadgeIds = updatedBadges;
    }

    return newlyUnlocked;
  }
}
