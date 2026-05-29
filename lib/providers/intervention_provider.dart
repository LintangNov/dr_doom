import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum InterventionLevel {
  normal,       // DRS 0 - 29
  waspada,      // DRS 30 - 49
  risikoSedang,  // DRS 50 - 69
  risikoTinggi,  // DRS 70 - 89
  kritis,       // DRS 90 - 100
}

class InterventionState {
  final InterventionLevel level;
  final double currentDrs;
  final double grayscaleIntensity;

  const InterventionState({
    required this.level,
    required this.currentDrs,
    required this.grayscaleIntensity,
  });

  InterventionState copyWith({
    InterventionLevel? level,
    double? currentDrs,
    double? grayscaleIntensity,
  }) {
    return InterventionState(
      level: level ?? this.level,
      currentDrs: currentDrs ?? this.currentDrs,
      grayscaleIntensity: grayscaleIntensity ?? this.grayscaleIntensity,
    );
  }
}

class InterventionEngine extends Notifier<InterventionState> {
  StreamSubscription<double>? _drsSubscription;

  @override
  InterventionState build() {
    // Automatically cleans up the subscription when the provider is disposed
    ref.onDispose(() {
      _drsSubscription?.cancel();
    });

    return const InterventionState(
      level: InterventionLevel.normal,
      currentDrs: 0.0,
      grayscaleIntensity: 0.0,
    );
  }

  /// Subscribes to a stream of DRS values.
  /// Automatically cleans up any active subscriptions to prevent memory leaks.
  void listenToDrsStream(Stream<double> drsStream) {
    _drsSubscription?.cancel();
    _drsSubscription = drsStream.listen(updateDrs);
  }

  /// Manually updates the current DRS value and evaluates the intervention state.
  void updateDrs(double drs) {
    final double clampedDrs = drs.clamp(0.0, 100.0);
    final InterventionLevel newLevel = _evaluateInterventionLevel(clampedDrs);
    final double newGrayscaleIntensity = _mapLevelToGrayscaleIntensity(newLevel);

    state = state.copyWith(
      level: newLevel,
      currentDrs: clampedDrs,
      grayscaleIntensity: newGrayscaleIntensity,
    );
  }

  InterventionLevel _evaluateInterventionLevel(double drs) {
    if (drs >= 90.0) {
      return InterventionLevel.kritis;
    } else if (drs >= 70.0) {
      return InterventionLevel.risikoTinggi;
    } else if (drs >= 50.0) {
      return InterventionLevel.risikoSedang;
    } else if (drs >= 30.0) {
      return InterventionLevel.waspada;
    } else {
      return InterventionLevel.normal;
    }
  }

  double _mapLevelToGrayscaleIntensity(InterventionLevel level) {
    switch (level) {
      case InterventionLevel.normal:
        return 0.0;
      case InterventionLevel.waspada:
        return 0.25;
      case InterventionLevel.risikoSedang:
        return 0.50;
      case InterventionLevel.risikoTinggi:
        return 0.75;
      case InterventionLevel.kritis:
        return 1.00;
    }
  }
}

// Providers Expositions
final interventionProvider =
    NotifierProvider<InterventionEngine, InterventionState>(() {
  return InterventionEngine();
});

final grayscaleIntensityProvider = Provider<double>((ref) {
  final interventionState = ref.watch(interventionProvider);
  return interventionState.grayscaleIntensity;
});
