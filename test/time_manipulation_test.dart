import 'package:flutter_test/flutter_test.dart';
import 'package:dr_doom/data/models/user_profile.dart';
import 'package:dr_doom/domain/services/system_clock_service.dart';
import 'package:dr_doom/domain/usecases/streak_manager.dart';

void main() {
  group('Time Manipulation Detection Tests', () {
    late UserProfile profile;
    late SystemClockService clockService;

    setUp(() {
      profile = UserProfile(
        id: 1,
        totalXp: 100,
        currentLevel: 1,
        currentStreak: 5,
        longestStreak: 5,
        lastActiveDate: DateTime(2026, 5, 29),
        unlockedBadgeIds: [],
        highRiskApps: [],
      );
      clockService = const SystemClockService();
    });

    test('Should NOT flag manipulation if clock ticks forward naturally', () async {
      final now = DateTime(2026, 5, 30, 12, 0);
      
      // First check (initialize boot time state)
      final manipulated = await clockService.checkAndDetectTimeManipulation(profile, now);
      expect(manipulated, isFalse);
      expect(profile.lastSystemTime, equals(now));
      expect(profile.isTimeManipulated, isFalse);
    });

    test('Should flag manipulation if system clock goes backwards', () async {
      // Initialize first
      final now = DateTime(2026, 5, 30, 12, 0);
      await clockService.checkAndDetectTimeManipulation(profile, now);

      // System clock goes backward by 2 hours
      final backwardTime = DateTime(2026, 5, 30, 10, 0);
      final manipulated = await clockService.checkAndDetectTimeManipulation(profile, backwardTime);
      
      expect(manipulated, isTrue);
      expect(profile.isTimeManipulated, isTrue);
    });

    test('StreakManager should reset streak to 0 if isTimeManipulated is true', () {
      profile.isTimeManipulated = true;
      const manager = StreakManager();
      
      final updated = manager.evaluateStreak(
        profile,
        DateTime(2026, 5, 30),
        dailyPeakDrs: 50.0,
        completedCognitiveBump: false,
      );

      expect(updated.currentStreak, equals(0));
    });
  });
}
