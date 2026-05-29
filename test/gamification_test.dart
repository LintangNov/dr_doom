import 'package:flutter_test/flutter_test.dart';
import 'package:dr_doom/data/models/user_profile.dart';
import 'package:dr_doom/domain/usecases/xp_calculator.dart';
import 'package:dr_doom/domain/usecases/streak_manager.dart';
import 'package:dr_doom/domain/usecases/achievement_checker.dart';

void main() {
  group('XPCalculator Tests', () {
    const xpCalculator = XPCalculator();
    late UserProfile profile;

    setUp(() {
      profile = UserProfile(
        id: 1,
        totalXp: 0,
        currentLevel: 1,
        currentStreak: 0,
        longestStreak: 0,
        lastActiveDate: null,
        unlockedBadgeIds: [],
        highRiskApps: [],
      );
    });

    test('Should calculate standard gains (bump + short session + streak)', () {
      final delta = xpCalculator.calculateDelta(
        completedCognitiveBump: true, // +50
        sessionMinutes: 20.0,         // < 30 (+30)
        currentStreak: 3,             // +30 (3 * 10)
        skippedCognitiveBump: false,
        peakDrs: 50.0,
      );

      expect(delta, equals(50 + 30 + 30)); // 110 XP
    });

    test('Daily streak bonus should cap at 100 XP', () {
      final delta = xpCalculator.calculateDelta(
        completedCognitiveBump: false,
        sessionMinutes: 40.0,         // no bonus
        currentStreak: 15,            // 15 * 10 = 150 -> caps at 100
        skippedCognitiveBump: false,
        peakDrs: 40.0,
      );

      expect(delta, equals(100));
    });

    test('Should calculate standard penalties (skip + peak DRS)', () {
      final delta = xpCalculator.calculateDelta(
        completedCognitiveBump: false,
        sessionMinutes: 40.0,
        currentStreak: 0,
        skippedCognitiveBump: true,  // -20
        peakDrs: 95.0,               // >= 90 (-50)
      );

      expect(delta, equals(-70));
    });

    test('Should apply XP delta and evaluate Duolingo leveling correctly', () {
      // 0 XP delta + 1200 XP gain -> 1200 XP, Level 2
      xpCalculator.applyXpChange(profile, 1200);
      expect(profile.totalXp, equals(1200));
      expect(profile.currentLevel, equals(2)); // (1200/1000).floor() + 1 = 2

      // 1200 XP + 900 XP gain -> 2100 XP, Level 3
      xpCalculator.applyXpChange(profile, 900);
      expect(profile.totalXp, equals(2100));
      expect(profile.currentLevel, equals(3));
    });

    test('XP should never go below 0 (clamping)', () {
      profile.totalXp = 40;
      xpCalculator.applyXpChange(profile, -100);
      expect(profile.totalXp, equals(0));
      expect(profile.currentLevel, equals(1));
    });
  });

  group('StreakManager Tests', () {
    const streakManager = StreakManager();
    late UserProfile profile;

    setUp(() {
      profile = UserProfile(
        id: 1,
        totalXp: 100,
        currentLevel: 1,
        currentStreak: 3,
        longestStreak: 3,
        lastActiveDate: DateTime(2026, 5, 28), // Yesterday
        unlockedBadgeIds: [],
        highRiskApps: [],
      );
    });

    test('Streak should reset to 0 if Peak DRS > 70 without completing bump', () {
      final today = DateTime(2026, 5, 29);
      streakManager.evaluateStreak(
        profile,
        today,
        dailyPeakDrs: 75.0,              // > 70
        completedCognitiveBump: false,    // didn't complete
      );

      expect(profile.currentStreak, equals(0));
      expect(profile.lastActiveDate, equals(today));
    });

    test('First time active should initialize streak to 1', () {
      profile.lastActiveDate = null;
      profile.currentStreak = 0;
      profile.longestStreak = 0;

      final today = DateTime(2026, 5, 29);
      streakManager.evaluateStreak(
        profile,
        today,
        dailyPeakDrs: 40.0,
        completedCognitiveBump: false,
      );

      expect(profile.currentStreak, equals(1));
      expect(profile.longestStreak, equals(1));
    });

    test('Consecutive day active should increment streak and update longestStreak', () {
      final today = DateTime(2026, 5, 29);
      streakManager.evaluateStreak(
        profile,
        today,
        dailyPeakDrs: 50.0,
        completedCognitiveBump: false,
      );

      expect(profile.currentStreak, equals(4)); // 3 + 1
      expect(profile.longestStreak, equals(4));
      expect(profile.lastActiveDate, equals(today));
    });

    test('Same day active should preserve streak and update timestamp', () {
      // Set last active to today
      final today = DateTime(2026, 5, 29, 10, 0);
      profile.lastActiveDate = today;

      final todayLater = DateTime(2026, 5, 29, 18, 0);
      streakManager.evaluateStreak(
        profile,
        todayLater,
        dailyPeakDrs: 40.0,
        completedCognitiveBump: false,
      );

      expect(profile.currentStreak, equals(3)); // remains 3
      expect(profile.lastActiveDate, equals(todayLater));
    });

    test('Inactivity of more than 1 day should reset streak to 1', () {
      final nextWeek = DateTime(2026, 6, 5);
      streakManager.evaluateStreak(
        profile,
        nextWeek,
        dailyPeakDrs: 45.0,
        completedCognitiveBump: false,
      );

      expect(profile.currentStreak, equals(1)); // reset to 1 due to inactivity gap
      expect(profile.lastActiveDate, equals(nextWeek));
    });
  });

  group('AchievementChecker Tests', () {
    const checker = AchievementChecker();
    late UserProfile profile;

    setUp(() {
      profile = UserProfile(
        id: 1,
        totalXp: 100,
        currentLevel: 1,
        currentStreak: 2,
        longestStreak: 2,
        lastActiveDate: null,
        unlockedBadgeIds: [],
        highRiskApps: [],
      );
    });

    test('Should unlock Benih Kesadaran on first completed bump', () {
      final newBadges = checker.checkNewBadges(
        profile,
        totalCognitiveBumpsCompleted: 1,
        initialDrs: 50.0,
        finalDrs: 50.0,
      );

      expect(newBadges, contains(AchievementChecker.badgeBenihKesadaran));
      expect(profile.unlockedBadgeIds, contains(AchievementChecker.badgeBenihKesadaran));
    });

    test('Should not unlock Benih Kesadaran twice (no duplicates)', () {
      profile.unlockedBadgeIds = [AchievementChecker.badgeBenihKesadaran];

      final newBadges = checker.checkNewBadges(
        profile,
        totalCognitiveBumpsCompleted: 2,
        initialDrs: 50.0,
        finalDrs: 50.0,
      );

      expect(newBadges, isEmpty);
      expect(profile.unlockedBadgeIds.length, equals(1));
    });

    test('Should unlock Quick Recover on DRS drop from 85+ to <30', () {
      final newBadges = checker.checkNewBadges(
        profile,
        totalCognitiveBumpsCompleted: 0,
        initialDrs: 85.0, // >= 80
        finalDrs: 25.0,   // < 30
      );

      expect(newBadges, contains(AchievementChecker.badgeQuickRecover));
      expect(profile.unlockedBadgeIds, contains(AchievementChecker.badgeQuickRecover));
    });

    test('Should NOT unlock Quick Recover if initial DRS is too low (<80)', () {
      final newBadges = checker.checkNewBadges(
        profile,
        totalCognitiveBumpsCompleted: 0,
        initialDrs: 78.0, // < 80
        finalDrs: 25.0,
      );

      expect(newBadges, isEmpty);
    });

    test('Should NOT unlock Quick Recover if final DRS is too high (>=30)', () {
      final newBadges = checker.checkNewBadges(
        profile,
        totalCognitiveBumpsCompleted: 0,
        initialDrs: 85.0,
        finalDrs: 32.0, // >= 30
      );

      expect(newBadges, isEmpty);
    });
  });
}
