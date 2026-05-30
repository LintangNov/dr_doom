import 'package:flutter/foundation.dart';
import '../domain/entities/sensor_bundle.dart';
import '../domain/usecases/calculate_risk_score.dart';

class BackgroundRiskCalculator {
  static const _calculator = CalculateRiskScore();
  static bool _isCalculating = false;

  /// Computes Doomscrolling Risk Score in a Background Isolate to prevent UI janks.
  /// If a calculation is already running, falls back to lightweight synchronous
  /// calculation on the main thread to prevent isolate queue overflow.
  static Future<double> calculate(SensorBundle bundle) async {
    if (_isCalculating) {
      return _executeCalculation(bundle);
    }

    _isCalculating = true;
    try {
      return await compute(_executeCalculation, bundle);
    } catch (e) {
      return _executeCalculation(bundle);
    } finally {
      _isCalculating = false;
    }
  }

  static double _executeCalculation(SensorBundle bundle) {
    return _calculator(bundle);
  }
}
