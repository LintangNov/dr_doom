import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/intervention_provider.dart';
import 'dart:ui';
import '../../../data/models/user_profile.dart';

class SliderValueNotifier extends Notifier<double?> {
  @override
  double? build() => null;

  void update(double? val) {
    state = val;
  }
}

final sliderValueProvider = NotifierProvider<SliderValueNotifier, double?>(() {
  return SliderValueNotifier();
});

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Accessibility detection: system high contrast and manual toggle high contrast
    final isSystemHighContrast = MediaQuery.highContrastOf(context);
    final isManualHighContrast = ref.watch(highContrastProvider);
    final useHighContrast = isSystemHighContrast || isManualHighContrast;

    // Get live DRS data from the Intervention Engine
    final interventionState = ref.watch(interventionProvider);
    final currentDrs = interventionState.currentDrs;
    final interventionLevel = interventionState.level;

    final themeMode = ref.watch(themeModeProvider);

    // Get user profile data dynamically from Isar
    final profileAsync = ref.watch(userProfileProvider);

    final sliderValue = ref.watch(sliderValueProvider);

    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    // Dynamic color palettes depending on contrast modes
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
        title: Text(
          'dr_doom Dashboard',
          style: theme.textTheme.titleLarge?.copyWith(
            color: textPrimaryColor,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.5,
            fontSize: textScaler.scale(22.0),
          ),
        ),
        actions: [
          // Dark/Light Theme Mode Toggle Button
          IconButton(
            icon: Icon(
              themeMode == ThemeMode.dark
                  ? Icons.light_mode_rounded
                  : themeMode == ThemeMode.light
                      ? Icons.dark_mode_rounded
                      : Icons.brightness_auto_rounded,
              color: textSecondaryColor,
              size: 22,
            ),
            tooltip: themeMode == ThemeMode.dark
                ? 'Ubah ke Mode Terang'
                : themeMode == ThemeMode.light
                    ? 'Ubah ke Mode Gelap'
                    : 'Ubah ke Mode Sistem',
            onPressed: () {
              // Cycle: system -> light -> dark -> system
              if (themeMode == ThemeMode.system) {
                ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
              } else if (themeMode == ThemeMode.light) {
                ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
              } else {
                ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
              }
            },
          ),
          const SizedBox(width: 4),

          // Accessibility Switch for High Contrast Mode
          Row(
            children: [
              Icon(
                useHighContrast ? Icons.accessibility_new : Icons.accessibility,
                color: useHighContrast
                    ? (theme.brightness == Brightness.dark ? Colors.yellow : Colors.blue)
                    : textSecondaryColor,
                size: 20,
              ),
              const SizedBox(width: 4),
              Text(
                'High Contrast',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: textSecondaryColor,
                  fontWeight: useHighContrast ? FontWeight.bold : FontWeight.normal,
                  fontSize: textScaler.scale(12.0),
                ),
              ),
              Switch(
                value: isManualHighContrast,
                onChanged: (val) {
                  ref.read(highContrastProvider.notifier).toggle(val);
                },
                activeThumbColor: useHighContrast
                    ? (theme.brightness == Brightness.dark ? Colors.yellow : Colors.black)
                    : theme.colorScheme.primary,
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: SafeArea(
        child: profileAsync.when(
          data: (profile) {
            if (profile.showPenaltyWarning) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                _showPenaltyDialog(context, ref, theme, textSecondaryColor);
              });
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dynamic Greeting & Level Indicator
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: cardBorder,
                      gradient: useHighContrast
                          ? null
                          : LinearGradient(
                              colors: theme.brightness == Brightness.dark
                                  ? AppColors.calmGradientDark
                                  : AppColors.calmGradientLight,
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Halo Pejuang Kesadaran!',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: useHighContrast ? textPrimaryColor : Colors.white70,
                            fontWeight: FontWeight.w600,
                            fontSize: textScaler.scale(14.0),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Level ${profile.currentLevel}',
                          style: theme.textTheme.titleLarge?.copyWith(
                            color: useHighContrast ? textPrimaryColor : Colors.white,
                            fontSize: textScaler.scale(28.0),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // XP Progression Text & Micro Progress Bar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'XP: ${profile.totalXp} / ${(profile.currentLevel) * 1000} XP',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: useHighContrast ? textSecondaryColor : Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: textScaler.scale(12.0),
                              ),
                            ),
                            Text(
                              '${((profile.totalXp % 1000) / 10).toStringAsFixed(0)}%',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: useHighContrast ? textSecondaryColor : Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: textScaler.scale(12.0),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: (profile.totalXp % 1000) / 1000.0,
                            minHeight: 10,
                            backgroundColor: useHighContrast
                                ? (theme.brightness == Brightness.dark
                                    ? Colors.grey.shade800
                                    : Colors.grey.shade300)
                                : Colors.white24,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              useHighContrast
                                  ? (theme.brightness == Brightness.dark
                                      ? Colors.yellow
                                      : Colors.black)
                                  : theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // DRS GAUGE & INDICATOR RING (WOW FACTOR)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(24),
                        border: cardBorder,
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Doomscrolling Risk Score (DRS)',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: textPrimaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: textScaler.scale(16.0),
                            ),
                          ),
                          const SizedBox(height: 24),
                          // Custom animated gauge using TweenAnimationBuilder
                          TweenAnimationBuilder<double>(
                            tween: Tween<double>(begin: 0, end: currentDrs),
                            duration: const Duration(milliseconds: 1000),
                            curve: Curves.easeOutBack,
                            builder: (context, animatedDrs, child) {
                              final evaluatedColor = _getDrsDynamicColor(
                                animatedDrs,
                                useHighContrast,
                                theme.brightness == Brightness.dark,
                              );
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer dynamic color ring
                                  SizedBox(
                                    width: 180,
                                    height: 180,
                                    child: CircularProgressIndicator(
                                      value: animatedDrs / 100.0,
                                      strokeWidth: 16.0,
                                      backgroundColor: useHighContrast
                                          ? (theme.brightness == Brightness.dark
                                              ? Colors.grey.shade900
                                              : Colors.grey.shade200)
                                          : theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                                      valueColor: AlwaysStoppedAnimation<Color>(evaluatedColor),
                                      strokeCap: StrokeCap.round,
                                    ),
                                  ),
                                  // Score number inside the ring
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        animatedDrs.toStringAsFixed(0),
                                        style: theme.textTheme.displayLarge?.copyWith(
                                          color: textPrimaryColor,
                                          fontSize: textScaler.scale(48.0),
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        _getInterventionName(interventionLevel).toUpperCase(),
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: evaluatedColor,
                                          fontWeight: FontWeight.w900,
                                          fontSize: textScaler.scale(12.0),
                                          letterSpacing: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Text(
                            _getDrsStatusMessage(interventionLevel),
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: textSecondaryColor,
                              fontSize: textScaler.scale(13.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // STATS: Active Streak (Calendar-based)
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.3,
                    children: [
                       _buildStatCard(
                        context,
                        title: 'Active Streak',
                        value: '${profile.currentStreak} Hari',
                        icon: Icons.local_fire_department_rounded,
                        iconColor: useHighContrast
                            ? (theme.brightness == Brightness.dark ? Colors.yellow : Colors.black)
                            : (theme.brightness == Brightness.dark
                                ? AppColors.doomOrangeDark
                                : AppColors.doomOrangeLight),
                        useHighContrast: useHighContrast,
                        border: cardBorder,
                        cardColor: cardColor,
                      ),
                      _buildStatCard(
                        context,
                        title: 'Rekor Terpanjang',
                        value: '${profile.longestStreak} Hari',
                        icon: Icons.emoji_events_rounded,
                        iconColor: useHighContrast
                            ? (theme.brightness == Brightness.dark ? Colors.yellow : Colors.black)
                            : (theme.brightness == Brightness.dark
                                ? const Color(0xFFFBBF24)
                                : const Color(0xFFD97706)),
                        useHighContrast: useHighContrast,
                        border: cardBorder,
                        cardColor: cardColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Autonomy Focus Switch Card
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
                          decoration: BoxDecoration(
                            color: profile.isMonitoringEnabled
                                ? const Color(0xFFE8F7EC)
                                : const Color(0xFFFEE2E2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            profile.isMonitoringEnabled
                                ? Icons.security_rounded
                                : Icons.security_update_warning_rounded,
                            color: profile.isMonitoringEnabled
                                ? const Color(0xFF10B981)
                                : const Color(0xFFEF4444),
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                profile.isMonitoringEnabled
                                    ? 'Perlindungan Aktif'
                                    : 'Perlindungan Jeda',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: textPrimaryColor,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                profile.isMonitoringEnabled
                                    ? 'Aplikasi sedang memantau scrolling Anda untuk mencegah distraksi.'
                                    : 'Fokus perlindungan dinonaktifkan sementara.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: textSecondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch(
                          value: profile.isMonitoringEnabled,
                          onChanged: (value) {
                            if (value) {
                              _enableMonitoring(ref);
                            } else {
                              _showMindfulPausePicker(context, ref, theme, textSecondaryColor);
                            }
                          },
                          activeColor: const Color(0xFF10B981),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Custom Scrolling Limit Slider Card
                  Container(
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
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFFFECE5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.timer_outlined,
                                color: Color(0xFFF97316),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Target Batas Scrolling',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Tentukan batas maksimal waktu scrolling yang terdeteksi sebelum Cognitive Bump diaktifkan.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: textSecondaryColor,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Batas Waktu:',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: textPrimaryColor,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFECE5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${(sliderValue ?? profile.doomscrollingThresholdMinutes.toDouble()).toInt()} Menit',
                                style: const TextStyle(
                                  color: Color(0xFFF97316),
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Slider(
                          value: sliderValue ?? profile.doomscrollingThresholdMinutes.toDouble(),
                          min: 5,
                          max: 60,
                          divisions: 11,
                          activeColor: const Color(0xFFF97316),
                          inactiveColor: const Color(0xFFFFECE5),
                          onChanged: (value) {
                            ref.read(sliderValueProvider.notifier).update(value);
                          },
                          onChangeEnd: (value) async {
                            try {
                              final isar = ref.read(isarProvider);
                              await isar.writeTxn(() async {
                                final p = await isar.userProfiles.get(1);
                                if (p != null) {
                                  p.doomscrollingThresholdMinutes = value.toInt();
                                  await isar.userProfiles.put(p);
                                }
                              });
                              ref.invalidate(userProfileProvider);
                            } catch (e) {
                              debugPrint('DR_DOOM_ERROR: Failed to update threshold: $e');
                            } finally {
                              ref.read(sliderValueProvider.notifier).update(null);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // GAMIFICATION BADGES UNLOCKED LIST
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: cardBorder,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pencapaian & Lencana',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: textPrimaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: textScaler.scale(16.0),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                             _buildBadgeIcon(
                              context,
                              id: 'Benih Kesadaran',
                              title: 'Benih Kesadaran',
                              description: 'Menyelesaikan bump pertama kali',
                              icon: Icons.spa_rounded,
                              activeColor: theme.brightness == Brightness.dark
                                  ? AppColors.successGreenDark
                                  : AppColors.successGreenLight,
                              isUnlocked: profile.unlockedBadgeIds.contains('Benih Kesadaran'),
                              useHighContrast: useHighContrast,
                            ),
                            _buildBadgeIcon(
                              context,
                              id: 'Quick Recover',
                              title: 'Quick Recover',
                              description: 'DRS turun dari 80+ ke <30',
                              icon: Icons.offline_bolt_rounded,
                              activeColor: theme.brightness == Brightness.dark
                                  ? const Color(0xFF22D3EE)
                                  : const Color(0xFF0891B2),
                              isUnlocked: profile.unlockedBadgeIds.contains('Quick Recover'),
                              useHighContrast: useHighContrast,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Panduan Istilah & Bantuan (Glossary/FAQ) Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24.0),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: cardBorder,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: Color(0xFFEEF2FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.help_outline_rounded,
                                color: Color(0xFF4A4CBE),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Panduan Istilah & Bantuan',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: textPrimaryColor,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildGlossaryItem(
                          context,
                          title: 'DRS (Doomscrolling Risk Score)',
                          description: 'Nilai dari 0 sampai 100 yang mendeteksi risiko doomscrolling berdasarkan kecepatan gulir dan durasi usapan layar Anda.',
                          useHighContrast: useHighContrast,
                        ),
                        const Divider(height: 24, thickness: 1),
                        _buildGlossaryItem(
                          context,
                          title: 'Active Streak (Hari Beruntun)',
                          description: 'Berapa hari berturut-turut Anda berhasil menjaga scrolling di bawah batas aman. Reset otomatis jika Anda melanggar pantauan.',
                          useHighContrast: useHighContrast,
                        ),
                        const Divider(height: 24, thickness: 1),
                        _buildGlossaryItem(
                          context,
                          title: 'Intervensi & Cognitive Bump',
                          description: 'Ketika DRS mencapai 70+, aplikasi akan memicu tantangan interaktif di layar (Cognitive Bump) untuk memutus kebiasaan gulir otomatis pikiran Anda.',
                          useHighContrast: useHighContrast,
                        ),
                        const Divider(height: 24, thickness: 1),
                        _buildGlossaryItem(
                          context,
                          title: 'Layanan Aksesibilitas',
                          description: 'Izin wajib Android untuk melacak usapan layar secara lokal. Data dijamin 100% aman dan diproses langsung di perangkat Anda.',
                          useHighContrast: useHighContrast,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Button to return to onboarding (navigation check)
                  Center(
                    child: TextButton.icon(
                      onPressed: () => context.go('/onboarding'),
                      icon: const Icon(Icons.arrow_back),
                      label: Text(
                        'Kembali ke Onboarding',
                        style: TextStyle(
                          fontSize: textScaler.scale(14),
                          fontWeight: FontWeight.bold,
                          color: useHighContrast
                              ? (theme.brightness == Brightness.dark
                                  ? Colors.yellow
                                  : Colors.black)
                              : theme.colorScheme.primary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          loading: () => const Center(
            child: Padding(
              padding: EdgeInsets.all(40.0),
              child: CircularProgressIndicator(),
            ),
          ),
          error: (err, stack) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Gagal memuat profil pengguna.',
                    style: TextStyle(color: textPrimaryColor, fontSize: textScaler.scale(16)),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(userProfileProvider),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
    required bool useHighContrast,
    required BoxBorder border,
    required Color cardColor,
  }) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    final Color titleColor = useHighContrast
        ? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87)
        : (theme.brightness == Brightness.dark
            ? AppColors.textSecondaryDark
            : AppColors.textSecondaryLight);

    final Color valueColor = useHighContrast
        ? (theme.brightness == Brightness.dark ? Colors.white : Colors.black)
        : (theme.brightness == Brightness.dark
            ? AppColors.textPrimaryDark
            : AppColors.textPrimaryLight);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: border,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6.0),
                decoration: BoxDecoration(
                  color: useHighContrast
                      ? Colors.transparent
                      : iconColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                  border: useHighContrast
                      ? Border.all(
                          color: theme.brightness == Brightness.dark ? Colors.white : Colors.black,
                          width: 2.0,
                        )
                      : null,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  fontSize: textScaler.scale(18.0),
                  color: valueColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontSize: textScaler.scale(11.0),
                  color: titleColor,
                  fontWeight: useHighContrast ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBadgeIcon(
    BuildContext context, {
    required String id,
    required String title,
    required String description,
    required IconData icon,
    required Color activeColor,
    required bool isUnlocked,
    required bool useHighContrast,
  }) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    final Color badgeIconColor = isUnlocked
        ? (useHighContrast
            ? (theme.brightness == Brightness.dark ? Colors.yellow : Colors.black)
            : activeColor)
        : (theme.brightness == Brightness.dark
            ? Colors.grey.shade800
            : Colors.grey.shade300);

    final Color textColor = isUnlocked
        ? (theme.brightness == Brightness.dark ? Colors.white : Colors.black)
        : Colors.grey;

    return Expanded(
      child: Tooltip(
        message: description,
        triggerMode: TooltipTriggerMode.tap,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: isUnlocked
                    ? (useHighContrast
                        ? Colors.transparent
                        : badgeIconColor.withValues(alpha: 0.15))
                    : Colors.transparent,
                shape: BoxShape.circle,
                border: Border.all(
                  color: badgeIconColor,
                  width: isUnlocked ? (useHighContrast ? 3.0 : 2.0) : 1.0,
                  style: isUnlocked ? BorderStyle.solid : BorderStyle.solid,
                ),
              ),
              child: Icon(
                icon,
                color: badgeIconColor,
                size: 32,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: textColor,
                fontWeight: isUnlocked ? FontWeight.bold : FontWeight.normal,
                fontSize: textScaler.scale(12.0),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              isUnlocked ? 'Terbuka' : 'Terkunci',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isUnlocked
                    ? (useHighContrast ? Colors.yellow : Colors.green)
                    : Colors.grey,
                fontSize: textScaler.scale(10.0),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getDrsDynamicColor(double drs, bool useHighContrast, bool isDark) {
    if (useHighContrast) {
      return isDark ? Colors.white : Colors.black;
    }

    if (drs >= 90.0) {
      return isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA); // Premium Kritis Purple
    } else if (drs >= 70.0) {
      return isDark ? AppColors.doomRedDark : AppColors.doomRedLight; // Risiko Tinggi
    } else if (drs >= 50.0) {
      return isDark ? AppColors.doomOrangeDark : AppColors.doomOrangeLight; // Risiko Sedang
    } else if (drs >= 30.0) {
      return isDark ? const Color(0xFFFBBF24) : const Color(0xFFD97706); // Waspada Amber
    } else {
      return isDark ? AppColors.successGreenDark : AppColors.successGreenLight; // Normal Green
    }
  }

  String _getInterventionName(InterventionLevel level) {
    switch (level) {
      case InterventionLevel.normal:
        return 'Normal';
      case InterventionLevel.waspada:
        return 'Waspada';
      case InterventionLevel.risikoSedang:
        return 'Risiko Sedang';
      case InterventionLevel.risikoTinggi:
        return 'Risiko Tinggi';
      case InterventionLevel.kritis:
        return 'Kritis';
    }
  }

  String _getDrsStatusMessage(InterventionLevel level) {
    switch (level) {
      case InterventionLevel.normal:
        return 'Status Anda tenang dan seimbang. Nikmati momen kesadaran penuh!';
      case InterventionLevel.waspada:
        return 'Tingkat fokus sedikit terpecah. Ambil nafas dalam-dalam.';
      case InterventionLevel.risikoSedang:
        return 'Risiko doomscrolling terdeteksi. Layar mulai meredup secara halus.';
      case InterventionLevel.risikoTinggi:
        return 'Risiko tinggi! Grayscale filter diaktifkan untuk membantu Anda fokus.';
      case InterventionLevel.kritis:
        return 'Batas kritis! Selesaikan Cognitive Bump Challenge untuk membuka layar.';
    }
  }

  void _showPenaltyDialog(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    Color textSecondaryColor,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF1E293B).withValues(alpha: 0.85)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Color(0xFFFEE2E2),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.warning_amber_rounded,
                        color: Color(0xFFEF4444),
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Deteksi Upaya Menghindar!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Kami mendeteksi bahwa aplikasi ditutup paksa saat Anda berada dalam kondisi Doomscrolling tingkat tinggi. Untuk menjaga kejujuran dan komitmen Anda, pinalti telah diterapkan:\n\n'
                      '• Beruntun (Streak) reset menjadi 0 hari\n'
                      '• Pengurangan sebesar -100 XP\n\n'
                      'Jangan menyerah! Setiap kegagalan adalah langkah menuju kendali diri yang lebih baik. Mari kembali fokus hari ini!',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textSecondaryColor,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        try {
                          final isar = ref.read(isarProvider);
                          await isar.writeTxn(() async {
                            final p = await isar.userProfiles.get(1);
                            if (p != null) {
                              p.showPenaltyWarning = false;
                              await isar.userProfiles.put(p);
                            }
                          });
                        } catch (e) {
                          debugPrint('DR_DOOM_ERROR: Failed to dismiss penalty warning: $e');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFEF4444),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Saya Mengerti, Mulai Lagi',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showMindfulPausePicker(
    BuildContext context,
    WidgetRef ref,
    ThemeData theme,
    Color textSecondaryColor,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? const Color(0xFF1E293B).withValues(alpha: 0.85)
                      : Colors.white.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white.withValues(alpha: 0.1)
                        : Colors.black.withValues(alpha: 0.1),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.psychology_rounded,
                      color: Color(0xFF4A4CBE),
                      size: 44,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Jeda Fokus Sadar (Mindful Pause)',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Apakah Anda yakin ingin menonaktifkan perlindungan? Pilih durasi jeda untuk bernapas sejenak sebelum kembali fokus.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _disableMonitoring(ref, 15);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Perlindungan dinonaktifkan selama 15 menit.'),
                            backgroundColor: Color(0xFF4A4CBE),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A4CBE).withValues(alpha: 0.1),
                        foregroundColor: const Color(0xFF4A4CBE),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Jeda 15 Menit', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _disableMonitoring(ref, 60);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Perlindungan dinonaktifkan selama 1 jam.'),
                            backgroundColor: Color(0xFF4A4CBE),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4A4CBE).withValues(alpha: 0.1),
                        foregroundColor: const Color(0xFF4A4CBE),
                        minimumSize: const Size(double.infinity, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 0,
                      ),
                      child: const Text('Jeda 1 Jam', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: TextButton.styleFrom(
                        minimumSize: const Size(double.infinity, 48),
                      ),
                      child: Text(
                        'Batal (Tetap Lindungi Saya)',
                        style: TextStyle(
                          color: textSecondaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _enableMonitoring(WidgetRef ref) async {
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        final p = await isar.userProfiles.get(1);
        if (p != null) {
          p.isMonitoringEnabled = true;
          await isar.userProfiles.put(p);
        }
      });
    } catch (e) {
      debugPrint('DR_DOOM_ERROR: Failed to enable monitoring: $e');
    }
  }

  void _disableMonitoring(WidgetRef ref, int minutes) async {
    try {
      final isar = ref.read(isarProvider);
      await isar.writeTxn(() async {
        final p = await isar.userProfiles.get(1);
        if (p != null) {
          p.isMonitoringEnabled = false;
          await isar.userProfiles.put(p);
        }
      });
    } catch (e) {
      debugPrint('DR_DOOM_ERROR: Failed to disable monitoring: $e');
    }
  }

  Widget _buildGlossaryItem(
    BuildContext context, {
    required String title,
    required String description,
    required bool useHighContrast,
  }) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
            fontSize: textScaler.scale(13.0),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: theme.textTheme.bodySmall?.copyWith(
            color: useHighContrast
                ? (theme.brightness == Brightness.dark ? Colors.white70 : Colors.black87)
                : (theme.brightness == Brightness.dark
                    ? AppColors.textSecondaryDark
                    : AppColors.textSecondaryLight),
            fontSize: textScaler.scale(12.0),
            height: 1.4,
          ),
        ),
      ],
    );
  }
}
