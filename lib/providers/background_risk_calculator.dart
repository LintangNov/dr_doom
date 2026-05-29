import 'package:flutter/foundation.dart';
import '../domain/entities/sensor_bundle.dart';
import '../domain/usecases/calculate_risk_score.dart';

class BackgroundRiskCalculator {
  static const _calculator = CalculateRiskScore();

  /// Computes Doomscrolling Risk Score in a Background Isolate to prevent UI janks.
  static Future<double> calculate(SensorBundle bundle) async {
    return await compute(_executeCalculation, bundle);
  }

  static double _executeCalculation(SensorBundle bundle) {
    return _calculator(bundle);
  }
}
