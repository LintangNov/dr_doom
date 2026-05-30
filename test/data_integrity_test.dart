import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:dr_doom/data/models/user_profile.dart';
import 'package:dr_doom/data/models/scroll_session.dart';
import 'package:dr_doom/providers/database_provider.dart';
import 'package:dr_doom/providers/intervention_provider.dart';

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

class FakeScrollSessionCollection extends Fake implements IsarCollection<ScrollSession> {
  final List<ScrollSession> sessions = [];

  @override
  Future<ScrollSession?> get(Id id) async {
    return sessions.isNotEmpty ? sessions.first : null;
  }

  @override
  Future<Id> put(ScrollSession object) async {
    object.id ??= 1;
    if (!sessions.contains(object)) {
      sessions.add(object);
    }
    return object.id!;
  }
}

class FakeIsar extends Fake implements Isar {
  final FakeUserProfileCollection userProfilesCollection = FakeUserProfileCollection();
  final FakeScrollSessionCollection scrollSessionsCollection = FakeScrollSessionCollection();

  @override
  IsarCollection<T> collection<T>() {
    if (T == UserProfile) {
      return userProfilesCollection as IsarCollection<T>;
    }
    if (T == ScrollSession) {
      return scrollSessionsCollection as IsarCollection<T>;
    }
    throw UnimplementedError();
  }

  @override
  Future<T> writeTxn<T>(Future<T> Function() callback, {bool silent = false}) async {
    // In our test, writeTxn executes callback directly
    return await callback();
  }

  @override
  T writeTxnSync<T>(T Function() callback, {bool silent = false}) {
    return callback();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Data Integrity & Lost Update Concurrency Tests', () {
    late FakeIsar fakeIsar;
    late ProviderContainer container;

    setUp(() {
      fakeIsar = FakeIsar();
      container = ProviderContainer(
        overrides: [
          isarProvider.overrideWithValue(fakeIsar),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('Parallel completeActiveSession calls should accumulate XP atomically without Lost Updates', () async {
      // 1. Initialize user profile in Isar
      final profile = UserProfile(
        id: 1,
        totalXp: 100,
        currentLevel: 1,
        currentStreak: 2,
        longestStreak: 5,
        lastActiveDate: DateTime.now().subtract(const Duration(days: 1)),
        unlockedBadgeIds: [],
        highRiskApps: [],
      );
      await fakeIsar.collection<UserProfile>().put(profile);

      // 2. Set up a cached scroll session in the InterventionEngine
      final engine = container.read(interventionProvider.notifier);
      engine.mockLatestSessionForTest = ScrollSession(
        id: 1,
        startTime: DateTime.now().subtract(const Duration(minutes: 10)),
        endTime: DateTime.now().subtract(const Duration(minutes: 5)),
        appPackageName: 'com.example.doomapp',
        peakDrs: 80.0,
        avgDrs: 75.0,
        swipeCount: 10,
        tapCount: 2,
        completedCognitiveBump: false,
        isEvaded: false,
      );

      // Warm up the cached session in-memory by updating DRS
      engine.updateDrs(80.0);
      await Future.delayed(const Duration(milliseconds: 100));

      // 3. Trigger multiple completed sessions concurrently to simulate race conditions
      // In real scenarios, concurrent clicks or events might fire overlapping completes.
      // Thanks to our AsyncMutex and atomic writeTxn read-modify-writes, they should serialize and succeed!
      await Future.wait([
        engine.completeActiveSession(),
        engine.completeActiveSession(),
      ]);

      // 4. Verify that the UserProfile has accumulated the XP cleanly and atomically
      final updatedProfile = await fakeIsar.collection<UserProfile>().get(1);
      expect(updatedProfile, isNotNull);
      
      // Expected XP changes:
      // Starting: 100 XP
      // First session completion: +50 XP (bump) + 30 XP (session < 30 min) + 20 XP (streak bonus) = +100 XP -> Total: 200 XP
      // Second session completion: +50 XP (bump) + 30 XP (session < 30 min) + 20 XP (streak bonus) = +100 XP -> Total: 300 XP
      // Let's assert that the final XP is exactly 300 XP (or appropriate XP based on calculation)
      // Since first run updates streak and lastActiveDate, let's verify total XP is greater than starting XP and matches atomicity.
      expect(updatedProfile!.totalXp, isNot(equals(100)));
      expect(updatedProfile.totalXp, equals(300));
    });
  });
}
