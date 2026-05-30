import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import '../domain/entities/sensor_bundle.dart';
import '../domain/usecases/calculate_risk_score.dart';

class BackgroundRiskCalculator {
  static const _calculator = CalculateRiskScore();
  static bool _isCalculating = false;

  // Long-lived persistent background isolate components
  static IsarBackgroundWorker? _worker;

  /// Initializes the long-lived background isolate.
  /// This should be called once on app startup or database init to warm up the isolate.
  static Future<void> init() async {
    if (_worker != null) return;
    _worker = IsarBackgroundWorker();
    await _worker!.start();
    print('DR_DOOM_PERFORMANCE: Persistent background isolate spawned and warmed up successfully.');
  }

  /// Shutdown the persistent isolate to prevent zombie processes and memory leaks.
  /// Must be called when the app is shut down or when resources are cleaned up.
  static void dispose() {
    _worker?.stop();
    _worker = null;
    print('DR_DOOM_PERFORMANCE: Persistent background isolate killed and cleaned up successfully.');
  }

  /// Computes Doomscrolling Risk Score in a Background Isolate to prevent UI janks.
  /// Uses a persistent long-lived isolate to avoid spawning overhead,
  /// and falls back to main thread synchronous calculation if the isolate is busy.
  static Future<double> calculate(SensorBundle bundle) async {
    if (_isCalculating) {
      return _executeCalculation(bundle);
    }

    _isCalculating = true;
    try {
      if (_worker != null && _worker!.isActive) {
        return await _worker!.calculate(bundle);
      } else {
        // Isolate not warmed up, fall back to compute or synchronous
        return await compute(_executeCalculation, bundle);
      }
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

/// A long-lived, energy-efficient persistent isolate manager
class IsarBackgroundWorker {
  Isolate? _isolate;
  SendPort? _sendPort;
  final _receivePort = ReceivePort();
  Completer<double>? _completer;

  bool get isActive => _isolate != null && _sendPort != null;

  /// Spawns the long-lived background isolate and establishes method communication.
  Future<void> start() async {
    if (_isolate != null) return;

    _isolate = await Isolate.spawn(_isolateEntry, _receivePort.sendPort);

    final completer = Completer<void>();
    _receivePort.listen((message) {
      if (message is SendPort) {
        _sendPort = message;
        completer.complete();
      } else if (message is double) {
        _completer?.complete(message);
      }
    });

    await completer.future;
  }

  /// Calculates DRS using the persistent SendPort channel.
  Future<double> calculate(SensorBundle bundle) async {
    if (!isActive) {
      return const CalculateRiskScore()(bundle);
    }

    _completer = Completer<double>();
    _sendPort!.send(bundle);
    return _completer!.future;
  }

  /// Safely kills the isolate to prevent memory leaks and zombie processes.
  void stop() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _sendPort = null;
    _receivePort.close();
  }

  /// Entry point of the persistent background isolate.
  static void _isolateEntry(SendPort mainSendPort) {
    final isolateReceivePort = ReceivePort();
    mainSendPort.send(isolateReceivePort.sendPort);

    const calculator = CalculateRiskScore();

    isolateReceivePort.listen((message) {
      if (message is SensorBundle) {
        final score = calculator(message);
        mainSendPort.send(score);
      }
    });
  }
}
