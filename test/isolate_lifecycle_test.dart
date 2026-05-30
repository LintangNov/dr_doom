import 'package:flutter_test/flutter_test.dart';
import 'package:dr_doom/providers/background_risk_calculator.dart';
import 'package:dr_doom/domain/entities/sensor_bundle.dart';

void main() {
  group('Isolate Lifecycle & Zombie Prevention Tests', () {
    test('Worker should spawn and calculate successfully, then stop without leaving leaks', () async {
      final worker = IsarBackgroundWorker();
      
      // 1. Initial state
      expect(worker.isActive, isFalse);

      // 2. Start isolate
      await worker.start();
      expect(worker.isActive, isTrue);

      // 3. Perform a calculation
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

      final result = await worker.calculate(bundle);
      expect(result, equals(0.0));

      // 4. Stop isolate (kills the isolate immediately)
      worker.stop();
      expect(worker.isActive, isFalse);
    });
  });
}
