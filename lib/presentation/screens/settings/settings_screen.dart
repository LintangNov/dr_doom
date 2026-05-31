import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/permission_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    // Watch dynamic states for contrast and themes
    final isSystemHighContrast = MediaQuery.highContrastOf(context);
    final isManualHighContrast = ref.watch(highContrastProvider);
    final useHighContrast = isSystemHighContrast || isManualHighContrast;

    // Watch the active permission states
    final permissionState = ref.watch(permissionStateProvider);

    // Determine colors based on themes and high contrast mode
    final Color backgroundColor = useHighContrast
        ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
        : theme.scaffoldBackgroundColor;

    final Color cardColor = useHighContrast
        ? (theme.brightness == Brightness.dark ? Colors.black : Colors.white)
        : theme.cardTheme.color ?? theme.colorScheme.surface;

    final Color textPrimaryColor = useHighContrast
        ? (theme.brightness == Brightness.dark ? Colors.white : Colors.black)
        : theme.colorScheme.onSurface;

    final Color textSecondaryColor = useHighContrast
        ? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87)
        : (theme.brightness == Brightness.dark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight);

    final Border cardBorder = useHighContrast
        ? Border.all(
            color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
            width: 3.0,
          )
        : Border.all(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF1E293B)
                : const Color(0xFFE2E2EC),
            width: 1.0,
          );

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textPrimaryColor),
          onPressed: () => context.pop(),
          tooltip: 'Kembali',
        ),
        title: Text(
          'Pengaturan Sistem',
          style: theme.textTheme.titleLarge?.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            fontSize: textScaler.scale(20.0),
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Header Info
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(24),
                  border: cardBorder,
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEEF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings_rounded,
                        color: Color(0xFF4A4CBE),
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Status Izin Perangkat',
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: textPrimaryColor,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'dr_doom memerlukan izin sistem berikut untuk memantau scrolling secara local dan menerapkan Cognitive Bump.',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: textSecondaryColor,
                              fontSize: textScaler.scale(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              Text(
                'Daftar Izin Wajib',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: textPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: textScaler.scale(16.0),
                ),
              ),
              const SizedBox(height: 12),

              // 1. Accessibility Service Permission Card
              _buildPermissionCard(
                context,
                ref: ref,
                title: 'Layanan Aksesibilitas',
                subtitle: 'Mendeteksi usapan layar (Wajib)',
                description: 'Digunakan secara lokal untuk mendeteksi intensitas usapan scrolling pada layar. Data Anda dijamin 100% aman di dalam perangkat.',
                isGranted: permissionState.accessibilityGranted,
                onRequest: () => ref.read(permissionStateProvider.notifier).requestAccessibility(),
                cardColor: cardColor,
                cardBorder: cardBorder,
                textPrimaryColor: textPrimaryColor,
                textSecondaryColor: textSecondaryColor,
                useHighContrast: useHighContrast,
              ),
              const SizedBox(height: 16),

              // 2. Usage Stats Permission Card
              _buildPermissionCard(
                context,
                ref: ref,
                title: 'Akses Statistik Penggunaan',
                subtitle: 'Mendeteksi aplikasi aktif (Wajib)',
                description: 'Memantau ketika Anda sedang membuka aplikasi media sosial atau aplikasi lain yang berpotensi memicu doomscrolling.',
                isGranted: permissionState.usageStatsGranted,
                onRequest: () => ref.read(permissionStateProvider.notifier).requestUsageStats(),
                cardColor: cardColor,
                cardBorder: cardBorder,
                textPrimaryColor: textPrimaryColor,
                textSecondaryColor: textSecondaryColor,
                useHighContrast: useHighContrast,
              ),
              const SizedBox(height: 16),

              // 3. Overlay (Display Over Other Apps) Permission Card
              _buildPermissionCard(
                context,
                ref: ref,
                title: 'Tampilkan di Atas Aplikasi Lain',
                subtitle: 'Menampilkan intervensi visual (Wajib)',
                description: 'Digunakan untuk menampilkan overlay Cognitive Bump (pertanyaan matematika / jeda fokus) langsung di atas layar saat Anda terdeteksi melanggar batas.',
                isGranted: permissionState.overlayGranted,
                onRequest: () => ref.read(permissionStateProvider.notifier).requestOverlay(),
                cardColor: cardColor,
                cardBorder: cardBorder,
                textPrimaryColor: textPrimaryColor,
                textSecondaryColor: textSecondaryColor,
                useHighContrast: useHighContrast,
              ),
              const SizedBox(height: 24),

              // Security & Privacy Disclaimer Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: useHighContrast
                      ? Colors.transparent
                      : const Color(0xFFE8F7EC),
                  borderRadius: BorderRadius.circular(20),
                  border: useHighContrast ? cardBorder : null,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.lock_outline_rounded,
                      color: Color(0xFF10B981),
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Semua pemrosesan data dilakukan 100% secara lokal pada sistem HP Anda. Kami tidak pernah mengirim data interaksi layar maupun aktivitas aplikasi Anda keluar perangkat.',
                        style: GoogleFonts.manrope(
                          color: useHighContrast
                              ? textPrimaryColor
                              : const Color(0xFF0F5338),
                          fontSize: textScaler.scale(12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionCard(
    BuildContext context, {
    required WidgetRef ref,
    required String title,
    required String subtitle,
    required String description,
    required bool isGranted,
    required VoidCallback onRequest,
    required Color cardColor,
    required BoxBorder cardBorder,
    required Color textPrimaryColor,
    required Color textSecondaryColor,
    required bool useHighContrast,
  }) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    final statusColor = isGranted
        ? (theme.brightness == Brightness.dark
            ? AppColors.successGreenDark
            : AppColors.successGreenLight)
        : (theme.brightness == Brightness.dark
            ? AppColors.doomOrangeDark
            : AppColors.doomOrangeLight);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(24),
        border: cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: isGranted
                      ? const Color(0xFFE8F7EC)
                      : const Color(0xFFFFF2EC),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  isGranted ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
                  color: statusColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                        fontSize: textScaler.scale(15),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: textSecondaryColor,
                        fontWeight: FontWeight.w600,
                        fontSize: textScaler.scale(12),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              
              // Status Badge or Action Button
              isGranted
                  ? Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F7EC),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'Aktif',
                        style: GoogleFonts.manrope(
                          color: const Color(0xFF10B981),
                          fontWeight: FontWeight.w900,
                          fontSize: textScaler.scale(12),
                        ),
                      ),
                    )
                  : OutlinedButton(
                      onPressed: onRequest,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        minimumSize: Size.zero,
                        side: BorderSide(
                          color: useHighContrast
                              ? (theme.brightness == Brightness.dark ? Colors.white : Colors.black)
                              : statusColor,
                          width: 1.5,
                        ),
                        foregroundColor: useHighContrast ? textPrimaryColor : statusColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Perbaiki',
                        style: TextStyle(
                          fontSize: textScaler.scale(12),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            description,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textSecondaryColor,
              fontSize: textScaler.scale(13),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
