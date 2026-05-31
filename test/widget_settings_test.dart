import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dr_doom/presentation/screens/settings/settings_screen.dart';
import 'package:dr_doom/providers/permission_provider.dart';
import 'package:dr_doom/domain/services/permission_service.dart';

class FakePermissionService implements PermissionService {
  final bool accessibility;
  final bool usageStats;
  final bool overlay;
  
  bool requestedAccessibilityCalled = false;
  bool requestedUsageStatsCalled = false;
  bool requestedOverlayCalled = false;

  FakePermissionService({
    this.accessibility = false,
    this.usageStats = false,
    this.overlay = false,
  });

  @override
  Future<bool> isAccessibilityGranted() async => accessibility;

  @override
  Future<void> requestAccessibility() async {
    requestedAccessibilityCalled = true;
  }

  @override
  Future<bool> isUsageStatsGranted() async => usageStats;

  @override
  Future<void> requestUsageStats() async {
    requestedUsageStatsCalled = true;
  }

  @override
  Future<bool> isOverlayGranted() async => overlay;

  @override
  Future<void> requestOverlay() async {
    requestedOverlayCalled = true;
  }

  @override
  Future<bool> areAllPermissionsGranted() async {
    return accessibility && usageStats && overlay;
  }
}

void main() {
  testWidgets('SettingsScreen displays warning and repair buttons when permissions are pending', (WidgetTester tester) async {
    final fakePermissionService = FakePermissionService(
      accessibility: false,
      usageStats: false,
      overlay: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          permissionServiceProvider.overrideWithValue(fakePermissionService),
        ],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    // Let any immediate asynchronous checkPermissions calls finish
    await tester.pumpAndSettle();

    // Verify Title and Subtitle exist
    expect(find.text('Pengaturan Sistem'), findsOneWidget);
    expect(find.text('Status Izin Perangkat'), findsOneWidget);
    
    // Verify each permission card shows and lists "Perbaiki" button since they are not granted
    expect(find.text('Layanan Aksesibilitas'), findsOneWidget);
    expect(find.text('Akses Statistik Penggunaan'), findsOneWidget);
    expect(find.text('Tampilkan di Atas Aplikasi Lain'), findsOneWidget);
    
    // Check that we have three "Perbaiki" OutlinedButtons
    expect(find.text('Perbaiki'), findsNWidgets(3));

    // Tap the first OutlinedButton ("Perbaiki" for Accessibility)
    await tester.tap(find.text('Perbaiki').first);
    await tester.pump();

    // Verify callback was triggered
    expect(fakePermissionService.requestedAccessibilityCalled, isTrue);
  });

  testWidgets('SettingsScreen displays active badges and disables buttons when all permissions are granted', (WidgetTester tester) async {
    final fakePermissionService = FakePermissionService(
      accessibility: true,
      usageStats: true,
      overlay: true,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          permissionServiceProvider.overrideWithValue(fakePermissionService),
        ],
        child: const MaterialApp(
          home: SettingsScreen(),
        ),
      ),
    );

    // Let any immediate async calls finish
    await tester.pumpAndSettle();

    // Verify we have three "Aktif" badges
    expect(find.text('Aktif'), findsNWidgets(3));
    
    // Verify NO "Perbaiki" buttons exist
    expect(find.text('Perbaiki'), findsNothing);
  });
}
