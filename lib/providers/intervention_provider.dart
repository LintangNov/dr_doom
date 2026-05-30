import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar_community/isar.dart';
import '../data/models/scroll_session.dart';
import '../data/models/user_profile.dart';
import '../domain/services/system_clock_service.dart';
import '../domain/usecases/xp_calculator.dart';
import '../domain/usecases/streak_manager.dart';
import '../domain/usecases/achievement_checker.dart';
import '../providers/background_risk_calculator.dart';
import 'database_provider.dart';

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

class InterventionEngine extends Notifier<InterventionState> with WidgetsBindingObserver {
  StreamSubscription<double>? _drsSubscription;
  Timer? _cachingTimer;
  ScrollSession? _cachedSession;
  bool _isSessionDirty = false;

  // Properti unit testing untuk memintas Isar query FFI di lingkungan unit test
  ScrollSession? mockLatestSessionForTest;

  Isar? _isarInstance;
  Isar get _isar => (_isarInstance ??= ref.read(isarProvider))!;

  @override
  InterventionState build() {
    // Warm up the long-lived background isolate defensively
    unawaited(BackgroundRiskCalculator.init());

    // Register WidgetsBindingObserver to catch background transitions
    WidgetsBinding.instance.addObserver(this);

    // Setup periodic caching timer (flush to disk every 30 seconds)
    _cachingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      unawaited(_flushSessionToDisk());
    });

    // Automatically cleans up the subscription when the provider is disposed
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _drsSubscription?.cancel();
      _cachingTimer?.cancel();
      BackgroundRiskCalculator.dispose();
      unawaited(_flushSessionToDisk(isSyncFlush: true)); // flush outstanding updates synchronously
    });

    return const InterventionState(
      level: InterventionLevel.normal,
      currentDrs: 0.0,
      grayscaleIntensity: 0.0,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      // Immediate flush when backgrounded or detached to prevent data loss
      unawaited(_flushSessionToDisk());
    }
  }

  /// Subscribes to a stream of DRS values.
  /// Automatically cleans up any active subscriptions to prevent memory leaks.
  /// Integrates timeout and error handling to handle sensor death / Doze Mode gracefully.
  void listenToDrsStream(Stream<double> drsStream) {
    _drsSubscription?.cancel();
    _drsSubscription = drsStream
        .timeout(
          const Duration(seconds: 15),
          onTimeout: (sink) {
            sink.addError(TimeoutException('Sensor data stream timed out (15s inactive). OS kill or Doze Mode suspected.'));
          },
        )
        .listen(
          updateDrs,
          onError: (error) {
            handleSensorDeathOrTimeout(error);
          },
        );
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

    // Persist or update the session in the background
    unawaited(startOrUpdateSession(clampedDrs));
  }

  /// Gracefully degrades the intervention state to normal to prevent locking user out
  /// when the operating system kills sensors or activates battery saver.
  void handleSensorDeathOrTimeout(dynamic error) {
    state = state.copyWith(
      level: InterventionLevel.normal,
      currentDrs: 0.0,
      grayscaleIntensity: 0.0,
    );

    try {
      final isar = _isar;
      unawaited(_finalizeActiveSessionOnSensorDeath(isar));
    } catch (_) {
      // Safe guard during tests where Isar is not overridden
    }
  }

  Future<void> _finalizeActiveSessionOnSensorDeath(Isar isar) async {
    // If we have a cached session, finalize it and mark as clean
    if (_cachedSession != null) {
      _cachedSession!.endTime = DateTime.now();
      _cachedSession!.isEvaded = false;
      _isSessionDirty = true;
      await _flushSessionToDisk();
      return;
    }

    final latestSession = await isar.scrollSessions
        .where()
        .sortByStartTimeDesc()
        .findFirst();

    if (latestSession != null && latestSession.endTime.millisecondsSinceEpoch == latestSession.startTime.millisecondsSinceEpoch) {
      await isar.writeTxn(() async {
        latestSession.endTime = DateTime.now();
        latestSession.isEvaded = false; // Interrupted by OS, not user evasion
        await isar.scrollSessions.put(latestSession);
      });
    }
  }

  /// Dynamically updates the current scroll session in-memory to prevent disk wear.
  Future<void> startOrUpdateSession(double drs) async {
    try {
      final isar = _isar;
      final now = DateTime.now();

      // 1. If we don't have a cached session, try to load the latest or create one
      if (_cachedSession == null) {
        ScrollSession? latestSession;
        if (mockLatestSessionForTest != null) {
          latestSession = mockLatestSessionForTest;
        } else {
          latestSession = await isar.scrollSessions
              .where()
              .sortByStartTimeDesc()
              .findFirst();
        }

        bool shouldCreateNew = false;
        if (latestSession == null) {
          shouldCreateNew = true;
        } else {
          final timeSinceEnd = now.difference(latestSession.endTime).inMinutes;
          if (timeSinceEnd > 5 || latestSession.completedCognitiveBump || latestSession.isEvaded) {
            shouldCreateNew = true;
          }
        }

        if (shouldCreateNew) {
          _cachedSession = ScrollSession(
            startTime: now,
            endTime: now,
            appPackageName: 'com.example.doomapp', // General app placeholder
            peakDrs: drs,
            avgDrs: drs,
            swipeCount: 0,
            tapCount: 0,
            completedCognitiveBump: false,
            isEvaded: false,
          );
          
          // Write immediately on creation to generate database ID!
          await isar.writeTxn(() async {
            await isar.scrollSessions.put(_cachedSession!);
          });
        } else {
          _cachedSession = latestSession;
        }
      }

      // 2. Update the session properties in-memory
      if (_cachedSession != null) {
        _cachedSession!.endTime = now;
        if (drs > _cachedSession!.peakDrs) {
          _cachedSession!.peakDrs = drs;
        }
        _cachedSession!.avgDrs = (_cachedSession!.avgDrs + drs) / 2.0;
        _isSessionDirty = true; // Mark as dirty (needs disk sync)
      }
    } catch (e, stack) {
      print('DR_DOOM_ERROR in startOrUpdateSession: $e\n$stack');
    }
  }

  /// Persists any pending in-memory session changes to physical Isar database.
  Future<void> _flushSessionToDisk({bool isSyncFlush = false}) async {
    if (!_isSessionDirty || _cachedSession == null) return;

    try {
      final isar = _isar;
      
      if (isSyncFlush) {
        isar.writeTxnSync(() {
          isar.scrollSessions.putSync(_cachedSession!);
        });
      } else {
        await isar.writeTxn(() async {
          await isar.scrollSessions.put(_cachedSession!);
        });
      }
      
      _isSessionDirty = false;
      print('DR_DOOM_PERFORMANCE: Successfully flushed in-memory scroll session to Isar physical DB (Disk write minimized).');
    } catch (e, stack) {
      print('DR_DOOM_ERROR in _flushSessionToDisk: $e\n$stack');
    }
  }

  /// Marks the current active scroll session as successfully completed (solved the cognitive bump).
  /// Performs anti-cheat time check, calculates XP gains, evaluates streaks and badge achievements.
  Future<void> completeActiveSession() async {
    try {
      final isar = _isar;
      
      if (_cachedSession != null) {
        _cachedSession!.completedCognitiveBump = true;
        _cachedSession!.endTime = DateTime.now();
        _isSessionDirty = true;
        await _flushSessionToDisk();
      } else {
        final latestSession = await isar.scrollSessions
            .where()
            .sortByStartTimeDesc()
            .findFirst();

        if (latestSession != null && !latestSession.completedCognitiveBump) {
          await isar.writeTxn(() async {
            latestSession.completedCognitiveBump = true;
            latestSession.endTime = DateTime.now();
            await isar.scrollSessions.put(latestSession);
          });
        }
      }

      // Re-read to guarantee we have the final values
      final latestSession = _cachedSession ?? await isar.scrollSessions
          .where()
          .sortByStartTimeDesc()
          .findFirst();

      if (latestSession != null) {
        // Fetch UserProfile and update XP/Streak/Achievements
        final profile = await isar.userProfiles.get(1);
        if (profile != null) {
          // 1. Keamanan: Pengecekan manipulasi waktu sistem menggunakan monotonic clock native
          final clockService = const SystemClockService();
          await clockService.checkAndDetectTimeManipulation(profile, DateTime.now());

          // 2. Evaluasi penambahan XP
          const xpCalculator = XPCalculator();
          final delta = xpCalculator.calculateDelta(
            completedCognitiveBump: true,
            sessionMinutes: latestSession.endTime.difference(latestSession.startTime).inSeconds / 60.0,
            currentStreak: profile.currentStreak,
            skippedCognitiveBump: false,
            peakDrs: latestSession.peakDrs,
          );

          xpCalculator.applyXpChange(profile, delta);

          // 3. Evaluasi Streak Harian
          const streakManager = StreakManager();
          streakManager.evaluateStreak(
            profile,
            DateTime.now(),
            dailyPeakDrs: latestSession.peakDrs,
            completedCognitiveBump: true,
          );

          // 4. Evaluasi Pencapaian & Badge
          const checker = AchievementChecker();
          checker.checkNewBadges(
            profile,
            totalCognitiveBumpsCompleted: 1,
            initialDrs: latestSession.peakDrs,
            finalDrs: 0.0,
          );

          await isar.writeTxn(() async {
            await isar.userProfiles.put(profile);
          });
        }
      }
    } catch (e) {
      // Safe guard
    }
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
