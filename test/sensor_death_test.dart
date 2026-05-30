import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dr_doom/providers/intervention_provider.dart';

void main() {
  group('Sensor Death & Timeout Degradation Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('InterventionEngine should gracefully degrade to normal on stream timeout', () async {
      final controller = StreamController<double>();
      final engine = container.read(interventionProvider.notifier);

      // Start listening to the stream
      engine.listenToDrsStream(controller.stream);

      // Trigger high risk score
      controller.add(95.0);
      await Future.delayed(Duration.zero);
      
      var state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.kritis));
      expect(state.currentDrs, equals(95.0));

      // Simulate a timeout/sensor death
      engine.handleSensorDeathOrTimeout(TimeoutException('Simulated sensor death'));

      state = container.read(interventionProvider);
      expect(state.level, equals(InterventionLevel.normal));
      expect(state.currentDrs, equals(0.0));
      expect(state.grayscaleIntensity, equals(0.0));

      await controller.close();
    });
  });
}
