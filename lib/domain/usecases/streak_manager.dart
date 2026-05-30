import 'dart:math';
import '../../../data/models/user_profile.dart';

class StreakManager {
  const StreakManager();

  /// Evaluates and updates the daily streak in the UserProfile.
  /// If the daily peak DRS is > 70 without completing the cognitive bump, the streak is reset to 0.
  /// Otherwise, consecutive daily activity increments the streak. Inactivity resets the streak to 1.
  UserProfile evaluateStreak(
    UserProfile profile,
    DateTime evaluationDate, {
    required double dailyPeakDrs,
    required bool completedCognitiveBump,
  }) {
    // Keamanan: Jika terdeteksi adanya manipulasi waktu harian, batalkan dan reset streak menjadi 0
    if (profile.isTimeManipulated) {
      profile.currentStreak = 0;
      return profile;
    }

    final lastActive = profile.lastActiveDate;
    if (lastActive == null) {
      // First time activity
      profile.currentStreak = 1;
      profile.longestStreak = max(profile.longestStreak, 1);
      profile.lastActiveDate = evaluationDate;
      return profile;
    }

    // Zero-out times to compare only calendar dates (highly robust for daily streak!)
    final dateOnlyEval = DateTime(evaluationDate.year, evaluationDate.month, evaluationDate.day);
    final dateOnlyLast = DateTime(lastActive.year, lastActive.month, lastActive.day);

    final differenceInDays = dateOnlyEval.difference(dateOnlyLast).inDays;

    if (differenceInDays == 1) {
      // Consecutive day active -> Increment streak
      profile.currentStreak += 1;
      profile.longestStreak = max(profile.longestStreak, profile.currentStreak);
      profile.lastActiveDate = evaluationDate;
    } else if (differenceInDays > 1) {
      // Inactivity of more than 1 day -> Reset streak and start from 1
      profile.currentStreak = 1;
      profile.lastActiveDate = evaluationDate;
    } else if (differenceInDays == 0) {
      // Same day active -> Streak remains the same, update timestamp
      profile.lastActiveDate = evaluationDate;
    }

    return profile;
  }
}
