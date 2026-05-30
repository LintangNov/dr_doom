import 'package:isar_community/isar.dart';
import '../../data/models/user_profile.dart';
import '../../data/models/scroll_session.dart';

/// Scans the database for any previous scroll sessions that were interrupted
/// (i.e. force closed) during a high DRS state without completing the cognitive bump.
/// If found, applies appropriate streak resets and XP penalties.
Future<void> runStartupRecoveryCheck(Isar isar, {List<ScrollSession>? mockSessionsForTest}) async {
  try {
    List<ScrollSession> danglingSessions;
    if (mockSessionsForTest != null) {
      danglingSessions = mockSessionsForTest
          .where((s) => s.peakDrs >= 70.0 && !s.completedCognitiveBump && !s.isEvaded)
          .toList();
    } else {
      danglingSessions = await isar.scrollSessions
          .filter()
          .peakDrsGreaterThan(69.9)
          .completedCognitiveBumpEqualTo(false)
          .isEvadedEqualTo(false)
          .findAll();
    }

    if (danglingSessions.isNotEmpty) {
      await isar.writeTxn(() async {
        for (final session in danglingSessions) {
          session.isEvaded = true;
          session.endTime = DateTime.now(); // retrospective end
          if (mockSessionsForTest == null) {
            await isar.scrollSessions.put(session);
          }
        }

        // Apply evasion penalty to UserProfile (ID: 1)
        final profile = await isar.userProfiles.get(1);
        if (profile != null) {
          profile.currentStreak = 0; // Reset streak to 0 as penalty!
          profile.totalXp = (profile.totalXp - 100).clamp(0, 999999); // deduct 100 XP
          await isar.userProfiles.put(profile);
        }
      });
      print('DR_DOOM_SECURITY: Detected force close/evasion. Applied streak reset and XP deduction penalties.');
    }
  } catch (e) {
    print('DR_DOOM_SECURITY: Error running startup recovery check: $e');
  }
}
