import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:dr_doom/data/models/user_profile.dart';
import 'package:dr_doom/data/models/scroll_session.dart';
import 'package:dr_doom/providers/database_provider.dart';
import 'package:dr_doom/providers/intervention_provider.dart';

/// A Fake implementation of [IsarCollection] for [UserProfile]
/// mimicking true Isar reactive stream behavior using [StreamController].
class FakeUserProfileCollection extends Fake implements IsarCollection<UserProfile> {
  final Map<Id, UserProfile> _data = {};
  final StreamController<UserProfile?> _streamController = StreamController<UserProfile?>.broadcast();

  @override
  Future<UserProfile?> get(Id id) async {
    return _data[id];
  }

  @override
  Future<Id> put(UserProfile object) async {
    object.id ??= 1;
    _data[object.id!] = object;
    _streamController.add(object);
    return object.id!;
  }

  @override
  Stream<UserProfile?> watchObject(Id id, {bool fireImmediately = false}) {
    final controller = StreamController<UserProfile?>();
    
    controller.onListen = () {
      // Emit the initial state asynchronously in a microtask to avoid async* race conditions
      scheduleMicrotask(() {
        if (!controller.isClosed) {
          controller.add(_data[id]);
        }
      });
      
      // Subscribe to future database updates
      final subscription = _streamController.stream.listen((updatedObj) {
        if (updatedObj?.id == id) {
          controller.add(updatedObj);
        }
      });
      
      controller.onCancel = () {
        subscription.cancel();
        controller.close();
      };
    };
    
    return controller.stream;
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

  @override
  Id putSync(ScrollSession object, {bool saveLinks = true}) {
    object.id ??= 1;
    if (!sessions.contains(object)) {
      sessions.add(object);
    }
    return object.id!;
  }
}

/// A Fake implementation of [Isar] database bypasses the FFI compiled library load
/// allowing integration tests to run effortlessly in unit test CLI environments.
class FakeIsar extends Fake implements Isar {
  final FakeUserProfileCollection _userProfiles = FakeUserProfileCollection();
  final FakeScrollSessionCollection _scrollSessions = FakeScrollSessionCollection();

  @override
  IsarCollection<T> collection<T>() {
    if (T == UserProfile) {
      return _userProfiles as IsarCollection<T>;
    }
    if (T == ScrollSession) {
      return _scrollSessions as IsarCollection<T>;
    }
    throw UnimplementedError('FakeIsar only supports UserProfile and ScrollSession collections in this integration test.');
  }

  @override
  Future<T> writeTxn<T>(Future<T> Function() callback, {bool silent = false}) async {
    // Directly execute write transactions synchronously
    return await callback();
  }

  @override
  Future<bool> close({bool deleteFromDisk = false}) async {
    return true;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Dr. Doom Integration Test Suite (Bypassing FFI via FakeIsar)', () {
    late FakeIsar fakeIsar;

    setUp(() {
      fakeIsar = FakeIsar();
    });

    test('Flow: Initialize database, trigger high DRS, verify InterventionEngine reacts with Risiko Tinggi', () async {
      // 1. Create a ProviderContainer with the FakeIsar override
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWithValue(fakeIsar),
        ],
      );
      addTearDown(container.dispose);

      // 2. Use container.listen to listen to userProfileProvider re-actively and robustly
      UserProfile? profileState;
      final subscription = container.listen<AsyncValue<UserProfile>>(
        userProfileProvider,
        (previous, next) {
          next.whenData((value) {
            profileState = value;
          });
        },
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      // Give a tiny delayed pause to process asynchronous stream initialization
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Verify initial profile values are set correctly
      expect(profileState, isNotNull);
      expect(profileState!.id, equals(1));
      expect(profileState!.totalXp, equals(0));
      expect(profileState!.currentLevel, equals(1));
      expect(profileState!.currentStreak, equals(0));

      // 3. Verify that the record is physically present inside FakeIsar collection
      final storedProfile = await fakeIsar.collection<UserProfile>().get(1);
      expect(storedProfile, isNotNull);
      expect(storedProfile!.totalXp, equals(0));

      // 4. Verify initial Intervention Engine State (must be normal)
      var interventionState = container.read(interventionProvider);
      expect(interventionState.level, equals(InterventionLevel.normal));
      expect(interventionState.currentDrs, equals(0.0));
      expect(interventionState.grayscaleIntensity, equals(0.0));

      // 5. Trigger an elevated DRS value of > 70 (e.g. 75.0) in the Intervention Engine
      final engine = container.read(interventionProvider.notifier);
      engine.mockLatestSessionForTest = ScrollSession(
        id: 1,
        startTime: DateTime.now().subtract(const Duration(minutes: 10)),
        endTime: DateTime.now().subtract(const Duration(minutes: 2)),
        appPackageName: 'com.example.doomapp',
        peakDrs: 50.0,
        avgDrs: 45.0,
        swipeCount: 5,
        tapCount: 1,
        completedCognitiveBump: false,
        isEvaded: false,
      );
      engine.updateDrs(75.0);

      // 6. Verify that the Intervention Engine evaluates the state to Risiko Tinggi
      interventionState = container.read(interventionProvider);
      expect(interventionState.level, equals(InterventionLevel.risikoTinggi));
      expect(interventionState.currentDrs, equals(75.0));
      expect(interventionState.grayscaleIntensity, equals(0.75));

      // 7. Verify the grayscale intensity provider delivers the correct value
      final intensity = container.read(grayscaleIntensityProvider);
      expect(intensity, equals(0.75));
    });

    test('Flow: Persist custom UserProfile in Isar, verify provider streams the updated values', () async {
      final container = ProviderContainer(
        overrides: [
          isarProvider.overrideWithValue(fakeIsar),
        ],
      );
      addTearDown(container.dispose);

      // Listen to profile updates
      UserProfile? updatedProfile;
      final subscription = container.listen<AsyncValue<UserProfile>>(
        userProfileProvider,
        (previous, next) {
          next.whenData((value) {
            updatedProfile = value;
          });
        },
        fireImmediately: true,
      );
      addTearDown(subscription.close);

      // Give a tiny delayed pause to process initial asynchronous stream initialization
      await Future.delayed(const Duration(milliseconds: 100));

      // Update the user profile inside a transaction
      await fakeIsar.writeTxn(() async {
        final profile = await fakeIsar.collection<UserProfile>().get(1);
        if (profile != null) {
          profile.totalXp = 1500;
          profile.currentLevel = 2;
          profile.currentStreak = 5;
          profile.unlockedBadgeIds = ['Benih Kesadaran'];
          await fakeIsar.collection<UserProfile>().put(profile);
        }
      });

      // Give a tiny delayed pause to process stream re-active emission from database update
      await Future.delayed(const Duration(milliseconds: 100));

      expect(updatedProfile, isNotNull);
      expect(updatedProfile!.totalXp, equals(1500));
      expect(updatedProfile!.currentLevel, equals(2));
      expect(updatedProfile!.currentStreak, equals(5));
      expect(updatedProfile!.unlockedBadgeIds, contains('Benih Kesadaran'));
    });
  });
}
