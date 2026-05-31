import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/database_provider.dart';
import '../../../providers/intervention_provider.dart';

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

    // Get user profile data dynamically from Isar
    final profileAsync = ref.watch(userProfileProvider);

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
                  const SizedBox(height: 16),
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
}
