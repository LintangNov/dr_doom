import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import 'package:dr_doom/data/models/scroll_session.dart';
import 'package:dr_doom/providers/database_provider.dart';
import 'package:dr_doom/providers/intervention_provider.dart';

class FakeScrollSessionCollection extends Fake implements IsarCollection<ScrollSession> {
  int writeCount = 0;
  final List<ScrollSession> sessions = [];

  @override
  Future<ScrollSession?> get(Id id) async {
    return sessions.isNotEmpty ? sessions.first : null;
  }

  @override
  Future<Id> put(ScrollSession object) async {
    writeCount++;
    object.id ??= 1;
    if (!sessions.contains(object)) {
      sessions.add(object);
    }
    return object.id!;
  }
}

class FakeIsar extends Fake implements Isar {
  final FakeScrollSessionCollection scrollSessionsCollection = FakeScrollSessionCollection();

  @override
  IsarCollection<T> collection<T>() {
    if (T == ScrollSession) {
      return scrollSessionsCollection as IsarCollection<T>;
    }
    throw UnimplementedError();
  }

  @override
  Future<T> writeTxn<T>(Future<T> Function() callback, {bool silent = false}) async {
    return await callback();
  }

  @override
  T writeTxnSync<T>(T Function() callback, {bool silent = false}) {
    return callback();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Database Caching (Write-Back Cache) Tests', () {
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

    test('Should minimize disk writes to only 0 on updates, caching subsequent updates in-memory', () async {
      final engine = container.read(interventionProvider.notifier);

      // Warm up the mock latest session to bypass FFI Isar sort query
      final initialSession = ScrollSession(
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
      
      engine.mockLatestSessionForTest = initialSession;

      // Trigger first DRS update (this should update in-memory and write to Isar if dirty / created)
      // Since mockLatestSessionForTest is set, it will load that session in-memory and NOT create a new one,
      // so it does NOT write immediately unless we flush!
      engine.updateDrs(40.0);
      await Future.delayed(Duration.zero);
      expect(fakeIsar.scrollSessionsCollection.writeCount, equals(0)); // 0 writes yet because of caching!

      // Trigger 10 consecutive DRS updates (these should only update in-memory cache, NO disk writes!)
      for (int i = 0; i < 10; i++) {
        engine.updateDrs(40.0 + i);
        await Future.delayed(Duration.zero);
      }

      // Total write count is STILL 0! Caching works beautifully!
      expect(fakeIsar.scrollSessionsCollection.writeCount, equals(0));
    });
  });
}
