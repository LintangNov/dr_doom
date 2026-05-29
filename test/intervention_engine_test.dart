import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dr_doom/providers/intervention_provider.dart';

void main() {
  late ProviderContainer container;

  setUp(() {
    container = ProviderContainer();
  });

  tearDown(() {
    container.dispose();
  });

  group('InterventionEngine State Transitions (via ProviderContainer)', () {
    test('Initial state should be Normal with 0.0 DRS and 0.0 Grayscale', () {
      final state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.normal));
      expect(state.currentDrs, equals(0.0));
      expect(state.grayscaleIntensity, equals(0.0));
    });

    test('DRS 15.0 should transition to Normal (intensity 0.0)', () {
      container.read(interventionProvider.notifier).updateDrs(15.0);
      final state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.normal));
      expect(state.currentDrs, equals(15.0));
      expect(state.grayscaleIntensity, equals(0.0));
    });

    test('DRS 35.0 should transition to Waspada (intensity 0.25)', () {
      container.read(interventionProvider.notifier).updateDrs(35.0);
      final state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.waspada));
      expect(state.currentDrs, equals(35.0));
      expect(state.grayscaleIntensity, equals(0.25));
    });

    test('DRS 55.0 should transition to Risiko Sedang (intensity 0.50)', () {
      container.read(interventionProvider.notifier).updateDrs(55.0);
      final state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.risikoSedang));
      expect(state.currentDrs, equals(55.0));
      expect(state.grayscaleIntensity, equals(0.50));
    });

    test('DRS 75.0 should transition to Risiko Tinggi (intensity 0.75)', () {
      container.read(interventionProvider.notifier).updateDrs(75.0);
      final state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.risikoTinggi));
      expect(state.currentDrs, equals(75.0));
      expect(state.grayscaleIntensity, equals(0.75));
    });

    test('DRS 95.0 should transition to Kritis (intensity 1.00)', () {
      container.read(interventionProvider.notifier).updateDrs(95.0);
      final state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.kritis));
      expect(state.currentDrs, equals(95.0));
      expect(state.grayscaleIntensity, equals(1.00));
    });

    test('DRS above 100 should be clamped to 100.0 (Kritis, intensity 1.00)', () {
      container.read(interventionProvider.notifier).updateDrs(150.0);
      final state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.kritis));
      expect(state.currentDrs, equals(100.0));
      expect(state.grayscaleIntensity, equals(1.00));
    });

    test('DRS below 0 should be clamped to 0.0 (Normal, intensity 0.0)', () {
      container.read(interventionProvider.notifier).updateDrs(-20.0);
      final state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.normal));
      expect(state.currentDrs, equals(0.0));
      expect(state.grayscaleIntensity, equals(0.0));
    });

    test('Should listen and react correctly to DRS Stream', () async {
      final controller = StreamController<double>();
      container.read(interventionProvider.notifier).listenToDrsStream(controller.stream);

      // Push a series of DRS updates into the stream
      controller.add(20.0);
      await Future.delayed(Duration.zero);
      expect(container.read(interventionProvider).level, equals(InterventionLevel.normal));

      controller.add(40.0);
      await Future.delayed(Duration.zero);
      expect(container.read(interventionProvider).level, equals(InterventionLevel.waspada));

      controller.add(80.0);
      await Future.delayed(Duration.zero);
      expect(container.read(interventionProvider).level, equals(InterventionLevel.risikoTinggi));

      await controller.close();
    });
  });
}
