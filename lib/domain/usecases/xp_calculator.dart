import 'dart:math';
import '../../../data/models/user_profile.dart';

class XPCalculator {
  const XPCalculator();

  /// Constant threshold for each level up (e.g., 1000 XP per level)
  static const int xpPerLevel = 1000;

  /// Calculates the XP delta (change) based on scroll sessions and cognitive outcomes.
  int calculateDelta({
    required bool completedCognitiveBump,
    required double sessionMinutes,
    required int currentStreak,
    required bool skippedCognitiveBump,
    required double peakDrs,
  }) {
    int delta = 0;

    // --- Gaining Rules ---
    // 1. Selesaikan cognitive bump (+50 XP)
    if (completedCognitiveBump) {
      delta += 50;
    }

    // 2. Sesi < 30 menit (+30 XP)
    if (sessionMinutes < 30.0) {
      delta += 30;
    }

    // 3. Streak harian (+10 XP per hari, maks 100)
    if (currentStreak > 0) {
      final int streakBonus = currentStreak * 10;
      delta += min(streakBonus, 100);
    }

    // --- REMOVED PENALTIES ---
    // Skipping a cognitive bump or having a peak DRS >= 90 yields 0 XP addition, but never subtracts XP.

    return delta;
  }

  /// Evaluates new total XP and level after applying the delta, updating the profile safely.
  UserProfile applyXpChange(UserProfile profile, int delta) {
    // Clamping: XP cannot go below 0
    final int newTotalXp = max(0, profile.totalXp + delta);
    
    // Duolingo-style leveling: e.g. Level 1 starts at 0 XP, Level 2 at 1000 XP, etc.
    final int newLevel = (newTotalXp / xpPerLevel).floor() + 1;

    profile.totalXp = newTotalXp;
    profile.currentLevel = newLevel;

    return profile;
  }
}
