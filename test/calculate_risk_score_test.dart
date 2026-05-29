import 'package:flutter_test/flutter_test.dart';
import 'package:dr_doom/domain/entities/sensor_bundle.dart';
import 'package:dr_doom/domain/usecases/calculate_risk_score.dart';

void main() {
  late CalculateRiskScore calculateRiskScore;

  setUp(() {
    calculateRiskScore = const CalculateRiskScore();
  });

  group('CalculateRiskScore Tests', () {
    test('Zero Risk / Safe Scroll should return 0.0', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: false,
        isVeryStill: false,
        lux: 500.0,
        sessionMinutes: 5.0,
        isLateNight: false,
        isEvening: false,
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(0.0));
    });

    test('Swipe-tap ratio > 15 should add 25', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 20.0, // > 15
        rhythmicScrollMinutes: 0.0,
        isLyingDown: false,
        isVeryStill: false,
        lux: 500.0,
        sessionMinutes: 5.0,
        isLateNight: false,
        isEvening: false,
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(25.0));
    });

    test('Rhythmic scroll > 10 should add 15', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 12.0, // > 10
        isLyingDown: false,
        isVeryStill: false,
        lux: 500.0,
        sessionMinutes: 5.0,
        isLateNight: false,
        isEvening: false,
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(15.0));
    });

    test('Lying down & very still should add 20', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: true,
        isVeryStill: true, // both true
        lux: 500.0,
        sessionMinutes: 5.0,
        isLateNight: false,
        isEvening: false,
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(20.0));
    });

    test('Lying down only should NOT add 20', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: true,
        isVeryStill: false,
        lux: 500.0,
        sessionMinutes: 5.0,
        isLateNight: false,
        isEvening: false,
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(0.0));
    });

    test('Dark (lux < 5) & late night should add 20', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: false,
        isVeryStill: false,
        lux: 3.0, // < 5
        sessionMinutes: 5.0,
        isLateNight: true, // both true
        isEvening: false,
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(20.0));
    });

    test('Evening & dim (lux < 50) should add 10', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: false,
        isVeryStill: false,
        lux: 40.0, // < 50
        sessionMinutes: 5.0,
        isLateNight: false,
        isEvening: true, // both true
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(10.0));
    });

    test('Session minutes > 45 should add 30', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: false,
        isVeryStill: false,
        lux: 500.0,
        sessionMinutes: 50.0, // > 45
        isLateNight: false,
        isEvening: false,
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(30.0));
    });

    test('Session minutes > 20 but <= 45 should add 15', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: false,
        isVeryStill: false,
        lux: 500.0,
        sessionMinutes: 30.0, // > 20
        isLateNight: false,
        isEvening: false,
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(15.0));
    });

    test('Rapid switching should add 8', () {
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: false,
        isVeryStill: false,
        lux: 500.0,
        sessionMinutes: 5.0,
        isLateNight: false,
        isEvening: false,
        rapidSwitching: true, // true
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(8.0));
    });

    test('Bonus: Lying down + late night + dark (< 5 lux) should add 15 bonus', () {
      // Score calculation:
      // - isLyingDown & isVeryStill = +20 (requires both, so we make both true)
      // - lux < 5 & isLateNight = +20
      // - Bonus lying + night + dark = +15
      // Total score = 20 + 20 + 15 = 55
      const bundle = SensorBundle(
        swipeToTapRatio: 1.0,
        rhythmicScrollMinutes: 0.0,
        isLyingDown: true,
        isVeryStill: true,
        lux: 2.0,
        sessionMinutes: 5.0,
        isLateNight: true,
        isEvening: false,
        rapidSwitching: false,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(55.0));
    });

    test('Score should be clamped to a maximum of 100.0', () {
      // Aggregate scores that exceed 100:
      // - ratio > 15 = +25
      // - rhythmic > 10 = +15
      // - lying & still = +20
      // - dark & late night = +20
      // - session > 45 = +30
      // - rapid = +8
      // - bonus = +15
      // Total = 25 + 15 + 20 + 20 + 30 + 8 + 15 = 133
      const bundle = SensorBundle(
        swipeToTapRatio: 25.0,
        rhythmicScrollMinutes: 15.0,
        isLyingDown: true,
        isVeryStill: true,
        lux: 1.0,
        sessionMinutes: 50.0,
        isLateNight: true,
        isEvening: false,
        rapidSwitching: true,
      );

      final score = calculateRiskScore(bundle);
      expect(score, equals(100.0)); // Clamped to 100.0
    });
  });
}
