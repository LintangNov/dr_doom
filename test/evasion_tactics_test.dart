import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:dr_doom/data/models/user_profile.dart';
import 'package:dr_doom/data/models/scroll_session.dart';
import 'package:dr_doom/domain/services/startup_recovery.dart';

class FakeUserProfileCollection extends Fake implements IsarCollection<UserProfile> {
  UserProfile? storedProfile;

  @override
  Future<UserProfile?> get(Id id) async {
    return storedProfile;
  }

  @override
  Future<Id> put(UserProfile object) async {
    storedProfile = object;
    return object.id ?? 1;
  }
}

class FakeIsar extends Fake implements Isar {
  final FakeUserProfileCollection userProfilesCollection = FakeUserProfileCollection();

  @override
  IsarCollection<T> collection<T>() {
    if (T == UserProfile) {
      return userProfilesCollection as IsarCollection<T>;
    }
    throw UnimplementedError();
  }

  @override
  Future<T> writeTxn<T>(Future<T> Function() callback, {bool silent = false}) async {
    return await callback();
  }
}

void main() {
  group('Evasion Tactics & Startup Recovery Tests', () {
    late FakeIsar fakeIsar;

    setUp(() {
      fakeIsar = FakeIsar();
    });

    test('Recovery should reset streak and deduct XP if dangling high DRS session is found', () async {
      // Initialize a profile with active streak
      final profile = UserProfile(
        id: 1,
        totalXp: 500,
        currentLevel: 1,
        currentStreak: 5,
        longestStreak: 5,
        unlockedBadgeIds: [],
        highRiskApps: [],
      );
      await fakeIsar.collection<UserProfile>().put(profile);

      // Create a simulated dangling session (peak DRS = 80, not completed, not evaded)
      final session = ScrollSession(
        id: 1,
        startTime: DateTime.now().subtract(const Duration(minutes: 30)),
        endTime: DateTime.now().subtract(const Duration(minutes: 10)),
        appPackageName: 'com.example.doomapp',
        peakDrs: 80.0,
        avgDrs: 75.0,
        swipeCount: 10,
        tapCount: 2,
        completedCognitiveBump: false,
        isEvaded: false,
      );

      // Run recovery check with the mock session list
      await runStartupRecoveryCheck(fakeIsar, mockSessionsForTest: [session]);

      // Check results
      expect(session.isEvaded, isTrue); // should be marked as evaded!
      
      final updatedProfile = await fakeIsar.collection<UserProfile>().get(1);
      expect(updatedProfile, isNotNull);
      expect(updatedProfile!.currentStreak, equals(0)); // streak reset to 0!
      expect(updatedProfile!.totalXp, equals(400)); // XP deducted by 100!
    });

    test('Recovery should NOT apply penalties if session was already completed', () async {
      final profile = UserProfile(
        id: 1,
        totalXp: 500,
        currentLevel: 1,
        currentStreak: 5,
        longestStreak: 5,
        unlockedBadgeIds: [],
        highRiskApps: [],
      );
      await fakeIsar.collection<UserProfile>().put(profile);

      final session = ScrollSession(
        id: 1,
        startTime: DateTime.now().subtract(const Duration(minutes: 30)),
        endTime: DateTime.now().subtract(const Duration(minutes: 10)),
        appPackageName: 'com.example.doomapp',
        peakDrs: 80.0,
        avgDrs: 75.0,
        swipeCount: 10,
        tapCount: 2,
        completedCognitiveBump: true, // already completed!
        isEvaded: false,
      );

      await runStartupRecoveryCheck(fakeIsar, mockSessionsForTest: [session]);

      expect(session.isEvaded, isFalse);
      
      final updatedProfile = await fakeIsar.collection<UserProfile>().get(1);
      expect(updatedProfile!.currentStreak, equals(5)); // untouched!
      expect(updatedProfile!.totalXp, equals(500)); // untouched!
    });
  });
}
