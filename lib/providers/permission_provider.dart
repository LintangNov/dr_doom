import 'package:flutter_riverpod/flutter_riverpod.dart';

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

class PermissionNotifier extends Notifier<PermissionState> {
  @override
  PermissionState build() {
    return const PermissionState();
  }

  void grantAccessibility() {
    state = state.copyWith(accessibilityGranted: true);
  }

  void grantUsageStats() {
    state = state.copyWith(usageStatsGranted: true);
  }

  void grantOverlay() {
    state = state.copyWith(overlayGranted: true);
  }

  void resetAll() {
    state = const PermissionState();
  }
}

final permissionStateProvider = NotifierProvider<PermissionNotifier, PermissionState>(() {
  return PermissionNotifier();
});
