import 'package:flutter_test/flutter_test.dart';
import 'package:dr_doom/domain/entities/sensor_bundle.dart';
import 'package:dr_doom/providers/background_risk_calculator.dart';

void main() {
  group('Sensor Concurrency & Risk Calculator Gate Tests', () {
    test('BackgroundRiskCalculator should execute calculation successfully', () async {
      const bundle = SensorBundle(
        swipeToTapRatio: 2.0,
        rhythmicScrollMinutes: 5.0,
        isLyingDown: true,
        isVeryStill: true,
        lux: 3.0,
        sessionMinutes: 25.0,
        isLateNight: true,
        isEvening: false,
        rapidSwitching: true,
      );

      // Trigger calculation
      final score = await BackgroundRiskCalculator.calculate(bundle);
      
      // Expected score:
      // lying & still = 20
      // dark & late night = 20
      // session > 20 = 15
      // rapid switching = 8
      // bonus = 15
      // Total = 20 + 20 + 15 + 8 + 15 = 78
      expect(score, equals(78.0));
    });

    test('Concurrent calculator calls should trigger fallback and complete successfully without crash', () async {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: false,
        isVeryStill: false,
        lux: 100.0,
        sessionMinutes: 5.0,
        isLateNight: false,
        isEvening: false,
        rapidSwitching: false,
      );

      // Run multiple calculations in parallel using Future.wait
      final results = await Future.wait([
        BackgroundRiskCalculator.calculate(bundle),
        BackgroundRiskCalculator.calculate(bundle),
        BackgroundRiskCalculator.calculate(bundle),
      ]);

      // All of them should complete successfully and return 0.0
      expect(results[0], equals(0.0));
      expect(results[1], equals(0.0));
      expect(results[2], equals(0.0));
    });
  });
}
