import 'dart:async';
import '../domain/entities/sensor_bundle.dart';
import '../domain/usecases/calculate_risk_score.dart';

class BackgroundRiskCalculator {
  static const _calculator = CalculateRiskScore();

  /// Warmed up static instance for API compatibility
  static final IsarBackgroundWorker _worker = IsarBackgroundWorker();

  /// Initializes the risk calculator synchronously.
  static Future<void> init() async {
    await _worker.start();
    print('DR_DOOM_PERFORMANCE: Risk calculator initialized synchronously on main thread.');
  }

  /// Disposes resources.
  static void dispose() {
    _worker.stop();
    print('DR_DOOM_PERFORMANCE: Risk calculator disposed.');
  }

  /// Computes Doomscrolling Risk Score synchronously on the main thread to prevent
  /// serialization and context-switching overhead of a background isolate.
  static Future<double> calculate(SensorBundle bundle) async {
    return _calculator(bundle);
  }
}

/// A stub worker kept for backward compatibility and test stability.
/// Executes calculations synchronously on the main thread.
class IsarBackgroundWorker {
  bool _isActive = false;
  bool get isActive => _isActive;

  Future<void> start() async {
    _isActive = true;
  }

  Future<double> calculate(SensorBundle bundle) async {
    return const CalculateRiskScore()(bundle);
  }

  void stop() {
    _isActive = false;
  }
}
