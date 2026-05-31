import 'package:flutter/services.dart';

abstract class PermissionService {
  /// Checks if Accessibility permission is granted.
  /// Accessibility service is critical for on-device scrolling session monitoring.
  Future<bool> isAccessibilityGranted();

  /// Requests Accessibility permission from the user.
  /// Usually opens the System Settings where user can enable the accessibility service.
  Future<void> requestAccessibility();

  /// Checks if Usage Stats permission is granted.
  /// Usage Stats are required to detect which high-risk apps are active.
  Future<bool> isUsageStatsGranted();

  /// Requests Usage Stats permission.
  /// Usually opens the System Settings for usage access.
  Future<void> requestUsageStats();

  /// Checks if Draw Over Other Apps (Overlay) permission is granted.
  /// Overlay permission is required to display intervention elements over high-risk apps.
  Future<bool> isOverlayGranted();

  /// Requests Draw Over Other Apps (Overlay) permission.
  /// Usually opens the System Settings for display over other apps.
  Future<void> requestOverlay();

  /// Checks if all necessary permissions are granted.
  Future<bool> areAllPermissionsGranted();
}

class DevicePermissionService implements PermissionService {
  static const MethodChannel _channel = MethodChannel('com.example.dr_doom/permissions');

  const DevicePermissionService();

  @override
  Future<bool> isAccessibilityGranted() async {
    try {
      final bool? granted = await _channel.invokeMethod<bool>('isAccessibilityGranted');
      return granted ?? false;
    } on MissingPluginException {
      return true; // Fallback for tests/unsupported platforms
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> requestAccessibility() async {
    try {
      await _channel.invokeMethod<void>('requestAccessibility');
    } catch (_) {}
  }

  @override
  Future<bool> isUsageStatsGranted() async {
    try {
      final bool? granted = await _channel.invokeMethod<bool>('isUsageStatsGranted');
      return granted ?? false;
    } on MissingPluginException {
      return true; // Fallback for tests/unsupported platforms
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> requestUsageStats() async {
    try {
      await _channel.invokeMethod<void>('requestUsageStats');
    } catch (_) {}
  }

  @override
  Future<bool> isOverlayGranted() async {
    try {
      final bool? granted = await _channel.invokeMethod<bool>('isOverlayGranted');
      return granted ?? false;
    } on MissingPluginException {
      return true; // Fallback for tests/unsupported platforms
    } catch (_) {
      return false;
    }
  }

  @override
  Future<void> requestOverlay() async {
    try {
      await _channel.invokeMethod<void>('requestOverlay');
    } catch (_) {}
  }

  @override
  Future<bool> areAllPermissionsGranted() async {
    final a = await isAccessibilityGranted();
    final u = await isUsageStatsGranted();
    final o = await isOverlayGranted();
    return a && u && o;
  }
}
