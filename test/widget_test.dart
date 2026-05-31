import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:mockito/mockito.dart';
import 'package:dr_doom/main.dart';
import 'package:dr_doom/data/models/user_profile.dart';
import 'package:dr_doom/data/models/scroll_session.dart';
import 'package:dr_doom/providers/database_provider.dart';

class FakeUserProfileCollection extends Fake implements IsarCollection<UserProfile> {
  final Map<Id, UserProfile> _data = {};

  FakeUserProfileCollection() {
    _data[1] = UserProfile(
      id: 1,
      totalXp: 0,
      currentLevel: 1,
      currentStreak: 0,
      longestStreak: 0,
      unlockedBadgeIds: [],
      highRiskApps: [],
      isOnboardingCompleted: false,
      showPenaltyWarning: false,
      doomscrollingThresholdMinutes: 20,
      isMonitoringEnabled: true,
    );
  }

  @override
  Future<UserProfile?> get(Id id) async {
    return _data[id];
  }

  @override
  UserProfile? getSync(Id id) {
    return _data[id];
  }

  @override
  Future<Id> put(UserProfile object) async {
    object.id ??= 1;
    _data[object.id!] = object;
    return object.id!;
  }

  @override
  Stream<UserProfile?> watchObject(Id id, {bool fireImmediately = false}) {
    return Stream.value(_data[id]);
  }
}

class FakeScrollSessionCollection extends Fake implements IsarCollection<ScrollSession> {}

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
    throw UnimplementedError();
  }

  @override
  Future<T> writeTxn<T>(Future<T> Function() callback, {bool silent = false}) async {
    return await callback();
  }
}

void main() {
  testWidgets('App starts and loads OnboardingScreen smoke test', (WidgetTester tester) async {
    final fakeIsar = FakeIsar();

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          isarProvider.overrideWithValue(fakeIsar),
        ],
        child: const MyApp(),
      ),
    );

    // Wait for the GoRouter navigation and layouts to settle
    await tester.pumpAndSettle();

    // Verify that the Onboarding page contents are loaded
    expect(find.text('Selamat Datang di\ndr_doom'), findsOneWidget);
    expect(
      find.text('Taklukkan kebiasaan doomscrolling dan kembalikan fokus Anda.'),
      findsOneWidget,
    );
    expect(find.text('Selanjutnya'), findsOneWidget);
  });
}
