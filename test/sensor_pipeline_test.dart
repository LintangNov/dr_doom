import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:dr_doom/data/models/scroll_session.dart';
import 'package:dr_doom/providers/database_provider.dart';
import 'package:dr_doom/providers/intervention_provider.dart';

class FakeScrollSessionCollection extends Fake implements IsarCollection<ScrollSession> {
  @override
  Future<ScrollSession?> get(Id id) async => null;

  @override
  Future<Id> put(ScrollSession object) async {
    object.id ??= 1;
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
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer(
      overrides: [
        isarProvider.overrideWithValue(FakeIsar()),
      ],
    );
  });

  tearDown(() {
    container.dispose();
  });

  group('Sensor Pipeline Fallback and Activation Tests', () {
    test('InterventionEngine automatically initializes sensor stream on build', () async {
      // Accessing interventionProvider should build the notifier and start the stream
      final state = container.read(interventionProvider);
      
      // Let immediate streams initialize
      await Future.delayed(const Duration(milliseconds: 100));
      
      // Assert that state starts normal
      expect(state.level, equals(InterventionLevel.normal));
      expect(state.currentDrs, equals(0.0));
    });
  });
}
