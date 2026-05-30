import 'package:flutter/services.dart';
import '../../data/models/user_profile.dart';

class SystemClockService {
  static const MethodChannel _channel = MethodChannel('com.example.dr_doom/system_clock');

  const SystemClockService();

  /// Gets the monotonic system uptime in milliseconds from the native OS.
  /// If running on an unsupported platform or testing, it falls back to a stopwatch-based simulated uptime.
  Future<int> getSystemUptime() async {
    try {
      final int? uptime = await _channel.invokeMethod<int>('getSystemUptime');
      return uptime ?? (DateTime.now().millisecondsSinceEpoch - _startupTime.millisecondsSinceEpoch);
    } on MissingPluginException {
      return DateTime.now().millisecondsSinceEpoch - _startupTime.millisecondsSinceEpoch;
    } catch (e) {
      return DateTime.now().millisecondsSinceEpoch - _startupTime.millisecondsSinceEpoch;
    }
  }

  static final DateTime _startupTime = DateTime.now();

  /// Validates the current system time against native monotonic uptime to detect manual manipulation.
  /// Modifies and returns whether time was manipulated.
  Future<bool> checkAndDetectTimeManipulation(UserProfile profile, DateTime systemTimeNow) async {
    // If it was already flagged, keep it flagged or evaluate again
    final uptimeNow = await getSystemUptime();
    final systemTimeMs = systemTimeNow.millisecondsSinceEpoch;

    // Calculate current estimated boot time (System Time - Monotonic Uptime)
    final currentBootTime = systemTimeMs - uptimeNow;

    // 1. Check if system clock moved backwards relative to last saved system time
    if (profile.lastSystemTime != null) {
      if (systemTimeNow.isBefore(profile.lastSystemTime!)) {
        profile.isTimeManipulated = true;
        return true;
      }
    }

    // 2. Check boot time consistency if previous record exists
    if (profile.lastKnownBootTime != null && profile.lastKnownUptime != null) {
      final prevBootTime = profile.lastKnownBootTime!;
      final prevUptime = profile.lastKnownUptime!;

      // Only check boot time shift if the device wasn't rebooted (uptimeNow >= prevUptime)
      if (uptimeNow >= prevUptime) {
        final bootTimeDifference = (currentBootTime - prevBootTime).abs();
        
        // If boot time shifted by more than 15 seconds (15000ms), manual clock change is detected!
        if (bootTimeDifference > 15000) {
          profile.isTimeManipulated = true;
          return true;
        }
      }
    }

    // 3. Save/Update state for next checks
    profile.lastKnownBootTime = currentBootTime;
    profile.lastKnownUptime = uptimeNow;
    profile.lastSystemTime = systemTimeNow;

    return profile.isTimeManipulated;
  }
}
