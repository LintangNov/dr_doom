import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'core/constants/app_colors.dart';
import 'data/models/user_profile.dart';
import 'data/models/scroll_session.dart';
import 'domain/services/startup_recovery.dart';
import 'presentation/widgets/grayscale_filter.dart';
import 'presentation/widgets/cognitive_bump_overlay.dart';
import 'providers/database_provider.dart';
import 'providers/intervention_provider.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get application documents directory
  final dir = await getApplicationDocumentsDirectory();

  // Fetch or generate database encryption key securely using FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();
  String? base64Key = await secureStorage.read(key: 'isar_db_encryption_key');
  // ignore: unused_local_variable
  Uint8List encryptionKey;

  if (base64Key == null) {
    // Generate secure 32-byte key for AES-256 using cryptographically secure random number generator
    final random = Random.secure();
    final secureKey = Uint8List.fromList(List<int>.generate(32, (_) => random.nextInt(256)));
    encryptionKey = secureKey;
    await secureStorage.write(
      key: 'isar_db_encryption_key',
      value: base64.encode(secureKey),
    );
  } else {
    encryptionKey = base64.decode(base64Key);
  }

  // Open Isar database with collections schemas
  final isar = await Isar.open(
    [UserProfileSchema, ScrollSessionSchema],
    directory: dir.path,
    // Note: encryptionKey is only supported in Isar v4.x (SQLite storage engine).
    // The current version (isar_community v3.3.2) does not support native database encryption.
    // The secure key is generated and stored above to support future v4 migration or field-level encryption.
  );

  // Run startup recovery check defensively to penalize previous evasions (force close)
  await runStartupRecoveryCheck(isar);

  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final interventionState = ref.watch(interventionProvider);
    final themeMode = ref.watch(themeModeProvider);

    return GrayscaleFilter(
      child: MaterialApp.router(
        title: 'dr_doom',
        theme: AppColors.lightTheme,
        darkTheme: AppColors.darkTheme,
        themeMode: themeMode,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
        builder: (context, child) {
          return Stack(
            children: [
              if (child != null) child,
              // Full Screen System Overlay when in Kritis Intervention Level (DRS >= 90)
              if (interventionState.level == InterventionLevel.kritis)
                CognitiveBumpOverlay(
                  onDismiss: () {
                    // solved!
                    ref.read(interventionProvider.notifier).updateDrs(0.0);
                    ref.read(interventionProvider.notifier).completeActiveSession();
                  },
                ),
            ],
          );
        },
      ),
    );
  }
}
