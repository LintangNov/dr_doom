import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'core/constants/app_colors.dart';
import 'data/models/user_profile.dart';
import 'data/models/scroll_session.dart';
import 'providers/database_provider.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Get application documents directory
  final dir = await getApplicationDocumentsDirectory();

  // Fetch or generate database encryption key securely using FlutterSecureStorage
  const secureStorage = FlutterSecureStorage();
  String? base64Key = await secureStorage.read(key: 'isar_db_encryption_key');
  Uint8List encryptionKey;

  if (base64Key == null) {
    final secureKey = Isar.generateSecureKey();
    encryptionKey = Uint8List.fromList(secureKey);
    await secureStorage.write(
      key: 'isar_db_encryption_key',
      value: base64.encode(secureKey),
    );
  } else {
    encryptionKey = base64.decode(base64Key);
  }

  // Open Isar database with collections schemas and encryption enabled
  final isar = await Isar.open(
    [UserProfileSchema, ScrollSessionSchema],
    directory: dir.path,
    encryptionKey: encryptionKey,
  );

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

    return MaterialApp.router(
      title: 'dr_doom',
      theme: AppColors.lightTheme,
      darkTheme: AppColors.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
