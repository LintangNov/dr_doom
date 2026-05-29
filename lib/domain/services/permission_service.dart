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
