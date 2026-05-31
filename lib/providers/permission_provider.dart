import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/services/permission_service.dart';

class PermissionState {
  final bool accessibilityGranted;
  final bool usageStatsGranted;
  final bool overlayGranted;

  const PermissionState({
    this.accessibilityGranted = false,
    this.usageStatsGranted = false,
    this.overlayGranted = false,
  });

  PermissionState copyWith({
    bool? accessibilityGranted,
    bool? usageStatsGranted,
    bool? overlayGranted,
  }) {
    return PermissionState(
      accessibilityGranted: accessibilityGranted ?? this.accessibilityGranted,
      usageStatsGranted: usageStatsGranted ?? this.usageStatsGranted,
      overlayGranted: overlayGranted ?? this.overlayGranted,
    );
  }
}

final permissionServiceProvider = Provider<PermissionService>((ref) {
  return const DevicePermissionService();
});

class PermissionNotifier extends Notifier<PermissionState> with WidgetsBindingObserver {
  late PermissionService _permissionService;

  @override
  PermissionState build() {
    _permissionService = ref.watch(permissionServiceProvider);
    WidgetsBinding.instance.addObserver(this);
    
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
    });

    // Check permissions immediately on build
    checkPermissions();

    return const PermissionState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-verify actual OS permissions when the user returns to the app
      checkPermissions();
    }
  }

  Future<void> checkPermissions() async {
    final a = await _permissionService.isAccessibilityGranted();
    final u = await _permissionService.isUsageStatsGranted();
    final o = await _permissionService.isOverlayGranted();

    state = PermissionState(
      accessibilityGranted: a,
      usageStatsGranted: u,
      overlayGranted: o,
    );
  }

  Future<void> requestAccessibility() async {
    await _permissionService.requestAccessibility();
    await checkPermissions();
  }

  Future<void> requestUsageStats() async {
    await _permissionService.requestUsageStats();
    await checkPermissions();
  }

  Future<void> requestOverlay() async {
    await _permissionService.requestOverlay();
    await checkPermissions();
  }

  void resetAll() {
    state = const PermissionState();
  }
}

final permissionStateProvider = NotifierProvider<PermissionNotifier, PermissionState>(() {
  return PermissionNotifier();
});
