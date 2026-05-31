import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/permission_provider.dart';
import '../../../providers/database_provider.dart';
import '../../../data/models/user_profile.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 3) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textScaler = MediaQuery.textScalerOf(context);

    return Scaffold(
      body: Stack(
        children: [
          // 1. Dynamic Pastel Mesh Background (Alive & Glowing)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFE2F4E7), // Premium Mint Green (Mockup tone)
                    Color(0xFFEEF2FF), // Soft Periwinkle
                    Color(0xFFF5EEFF), // Soft Lavender
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Subtle glowing orb decorations
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFC7D2FE).withValues(alpha: 0.3),
              ),
            ),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFA7F3D0).withValues(alpha: 0.35),
              ),
            ),
          ),

          // 2. Main Content
          SafeArea(
            child: Column(
              children: [
                // Top Header Section
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _currentPage > 0
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.6),
                                shape: BoxShape.circle,
                                border: Border.all(color: const Color(0xFFE2E2EC)),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Color(0xFF0F172A)),
                                onPressed: _previousPage,
                              ),
                            )
                          : const SizedBox(width: 48, height: 48),
                      Text(
                        'dr_doom',
                        style: GoogleFonts.manrope(
                          fontSize: textScaler.scale(20.0),
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF4A4CBE),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(width: 48, height: 48),
                    ],
                  ),
                ),

                // Main Swipeable PageView
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    children: [
                      _buildWelcomeScreen(context, textScaler),
                      _buildAccessibilityScreen(context, textScaler),
                      _buildUsageScreen(context, textScaler),
                      _buildOverlayScreen(context, textScaler),
                    ],
                  ),
                ),

                // Dot Page Indicator & Footer Controls
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Smooth Dynamic Pill Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(4, (index) {
                          final isActive = _currentPage == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            margin: const EdgeInsets.symmetric(horizontal: 4.0),
                            height: 8,
                            width: isActive ? 24.0 : 8.0,
                            decoration: BoxDecoration(
                              color: isActive
                                  ? const Color(0xFF4A4CBE)
                                  : const Color(0xFFB5BAFF).withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 24),

                      // Floating primary trigger button based on active page
                      _buildActiveFooterButton(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WELCOME SCREEN (PAGE 1) ---
  Widget _buildWelcomeScreen(BuildContext context, TextScaler textScaler) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 24),
          // Large minimal Psychology/Fokus Mascot Icon
          _buildIllustrationContainer(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(28.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFEEF2FF),
                ),
                child: const Icon(
                  Icons.psychology_outlined,
                  size: 96,
                  color: Color(0xFF4A4CBE),
                ),
              ),
            ),
          ),
          const SizedBox(height: 48),

          // Headline & Text Block
          Text(
            'Selamat Datang di\ndr_doom',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: textScaler.scale(32.0),
              fontWeight: FontWeight.w800,
              height: 1.2,
              letterSpacing: -1.0,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Taklukkan kebiasaan doomscrolling dan kembalikan fokus Anda.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: textScaler.scale(16.0),
              height: 1.5,
              color: const Color(0xFF5C5A69),
            ),
          ),
          const SizedBox(height: 36),

          // Split Local Processing Badge Element (Aesthetic feedback)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.8),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE2E2EC)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_outline_rounded, color: Color(0xFF10B981), size: 20),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    '100% Pemrosesan Lokal\n(Privasi Aman di Perangkat Anda)',
                    textAlign: TextAlign.left,
                    style: GoogleFonts.manrope(
                      fontSize: textScaler.scale(12.0),
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- ACCESSIBILITY SCREEN (PAGE 2) ---
  Widget _buildAccessibilityScreen(BuildContext context, TextScaler textScaler) {
    final permissionState = ref.watch(permissionStateProvider);
    final isGranted = permissionState.accessibilityGranted;

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Illustration: Swiping screen finger representation
          _buildIllustrationContainer(
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Swiping gesture lines
                Positioned(
                  top: 40,
                  child: Icon(
                    Icons.swap_calls_rounded,
                    size: 80,
                    color: const Color(0xFFB5BAFF).withValues(alpha: 0.4),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFFEEF2FF),
                  ),
                  child: const Icon(
                    Icons.swipe_vertical_outlined,
                    size: 72,
                    color: Color(0xFF4A4CBE),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          Text(
            'Deteksi Gulir Layar',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: textScaler.scale(26.0),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Untuk melindungi fokus Anda, kami membutuhkan izin Aksesibilitas (Accessibility) guna mendeteksi pola usapan (swipe) berulang. Data Anda aman dan tidak pernah dikirim ke server luar.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: textScaler.scale(14.0),
              height: 1.5,
              color: const Color(0xFF5C5A69),
            ),
          ),
          const SizedBox(height: 24),

          // Step-by-Step Settings Instruction Card
          _buildInstructionCard(
            textScaler,
            title: 'Panduan Langkah Aksesibilitas:',
            steps: [
              'Ketuk tombol izin di bawah untuk membuka Pengaturan Sistem.',
              'Cari dan ketuk "Aplikasi Terinstall" (Installed Apps) atau "Layanan Tambahan" (Downloaded Services).',
              'Pilih "dr_doom" dan aktifkan "Gunakan dr_doom".',
            ],
          ),
          const SizedBox(height: 24),

          // Contextual Privacy Guarantee Notice
          _buildPrivacyDisclaimer(textScaler),
        ],
      ),
    );
  }

  // --- USAGE STATISTICS SCREEN (PAGE 3) ---
  Widget _buildUsageScreen(BuildContext context, TextScaler textScaler) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Illustration: Dashboard pie chart vector mock
          _buildIllustrationContainer(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF4A4CBE), width: 8),
                    ),
                  ),
                  const Positioned(
                    right: 15,
                    bottom: 15,
                    child: Icon(
                      Icons.pie_chart_rounded,
                      size: 48,
                      color: Color(0xFFB5BAFF),
                    ),
                  ),
                  const Icon(
                    Icons.app_registration_rounded,
                    size: 48,
                    color: Color(0xFF4A4CBE),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          Text(
            'Pemantauan Aplikasi',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: textScaler.scale(26.0),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Kami membutuhkan Akses Penggunaan (Usage Access) untuk mendeteksi saat Anda membuka aplikasi berisiko tinggi, sehingga sistem dapat memberikan peringatan tepat waktu.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: textScaler.scale(14.0),
              height: 1.5,
              color: const Color(0xFF5C5A69),
            ),
          ),
          const SizedBox(height: 24),

          // Step-by-Step Settings Instruction Card
          _buildInstructionCard(
            textScaler,
            title: 'Panduan Langkah Akses Penggunaan:',
            steps: [
              'Ketuk tombol izin di bawah.',
              'Temukan dan pilih aplikasi "dr_doom" di dalam daftar.',
              'Aktifkan opsi "Izinkan Akses Penggunaan" (Allow Usage Access).',
            ],
          ),
          const SizedBox(height: 24),

          // Contextual Privacy Guarantee Notice
          _buildPrivacyDisclaimer(textScaler),
        ],
      ),
    );
  }

  // --- OVERLAY SCREEN (PAGE 4) ---
  Widget _buildOverlayScreen(BuildContext context, TextScaler textScaler) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          // Illustration: Glassmorphic layered stack boxes mock representation
          _buildIllustrationContainer(
            child: SizedBox(
              width: 140,
              height: 100,
              child: Stack(
                children: [
                  Positioned(
                    left: 10,
                    top: 10,
                    child: Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E2EC)),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 10,
                    bottom: 10,
                    child: Container(
                      width: 90,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFB5BAFF), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4A4CBE).withValues(alpha: 0.1),
                            blurRadius: 10,
                            spreadRadius: 2,
                          )
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.layers_rounded,
                          color: Color(0xFF4A4CBE),
                          size: 28,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          Text(
            'Hamparan Intervensi',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: textScaler.scale(26.0),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Untuk membantu memecah siklus scrolling, kami membutuhkan izin Tampil di Atas Aplikasi Lain (Overlay) guna menerapkan filter layar atau tantangan kognitif.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: textScaler.scale(14.0),
              height: 1.5,
              color: const Color(0xFF5C5A69),
            ),
          ),
          const SizedBox(height: 24),

          // Step-by-Step Settings Instruction Card
          _buildInstructionCard(
            textScaler,
            title: 'Panduan Langkah Hamparan Intervensi:',
            steps: [
              'Ketuk tombol izin di bawah.',
              'Cari "dr_doom" dalam daftar aplikasi yang muncul.',
              'Aktifkan opsi "Izinkan Tampil di Atas Aplikasi Lain" (Allow display over other apps).',
            ],
          ),
          const SizedBox(height: 24),

          // Contextual Privacy Guarantee Notice
          _buildPrivacyDisclaimer(textScaler),
        ],
      ),
    );
  }

  // --- REUSABLE CARD & WIDGET BUILDERS ---

  // 1. Frosted Glass Illustration Card (Glassmorphism design aesthetic)
  Widget _buildIllustrationContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      height: 180,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: 0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: child,
    );
  }

  // 2. Step-by-Step Instructions Card (Usability enhancer)
  Widget _buildInstructionCard(TextScaler textScaler, {required String title, required List<String> steps}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E2EC)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: textScaler.scale(13.0),
              fontWeight: FontWeight.bold,
              color: const Color(0xFF4A4CBE),
            ),
          ),
          const SizedBox(height: 12),
          ...List.generate(steps.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 2.0),
                    padding: const EdgeInsets.all(4.0),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFEEF2FF),
                    ),
                    child: Text(
                      '${index + 1}',
                      style: GoogleFonts.manrope(
                        fontSize: textScaler.scale(10.0),
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF4A4CBE),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      steps[index],
                      style: GoogleFonts.manrope(
                        fontSize: textScaler.scale(12.0),
                        height: 1.4,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  // 3. Privacy Disclaimer Guarantee notice card
  Widget _buildPrivacyDisclaimer(TextScaler textScaler) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F7EC), // Pastel success green fill
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFAEEFB3).withValues(alpha: 0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_rounded, color: Color(0xFF0D9488), size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '🔒 Jaminan Privasi: Pemrosesan data sepenuhnya berjalan luring (offline) di perangkat Anda. dr_doom tidak mengumpulkan atau mengirim data Anda ke server luar.',
              style: GoogleFonts.manrope(
                fontSize: textScaler.scale(11.0),
                fontWeight: FontWeight.w600,
                height: 1.4,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 4. Dynamic Footer Controls (Handles simulated clicks, transitions and state updates)
  Widget _buildActiveFooterButton(BuildContext context) {
    final permissionState = ref.watch(permissionStateProvider);
    final isAccessibility = permissionState.accessibilityGranted;
    final isUsage = permissionState.usageStatsGranted;
    final isOverlay = permissionState.overlayGranted;

    if (_currentPage == 0) {
      // Screen 1: Welcome
      return ElevatedButton(
        onPressed: _nextPage,
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Selanjutnya'),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward_rounded, size: 20),
          ],
        ),
      );
    } else if (_currentPage == 1) {
      // Screen 2: Accessibility
      return ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 56),
      ).backgroundColor != null // Simple trigger
          ? Container()
          : AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 56,
              child: ElevatedButton.icon(
                onPressed: () {
                  ref.read(permissionStateProvider.notifier).grantAccessibility();
                  Future.delayed(const Duration(milliseconds: 600), _nextPage);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: isAccessibility ? const Color(0xFFE8F7EC) : const Color(0xFF4A4CBE),
                  foregroundColor: isAccessibility ? const Color(0xFF0D9488) : Colors.white,
                  side: isAccessibility ? const BorderSide(color: Color(0xFF10B981), width: 1.5) : null,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                  elevation: 0,
                ),
                icon: Icon(isAccessibility ? Icons.check_circle_rounded : Icons.lock_outline_rounded, size: 20),
                label: Text(
                  isAccessibility ? 'Izin Aksesibilitas Diberikan ✔' : 'Berikan Izin Aksesibilitas',
                ),
              ),
            );
    } else if (_currentPage == 2) {
      // Screen 3: Usage Access
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () {
            ref.read(permissionStateProvider.notifier).grantUsageStats();
            Future.delayed(const Duration(milliseconds: 600), _nextPage);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isUsage ? const Color(0xFFE8F7EC) : const Color(0xFF4A4CBE),
            foregroundColor: isUsage ? const Color(0xFF0D9488) : Colors.white,
            side: isUsage ? const BorderSide(color: Color(0xFF10B981), width: 1.5) : null,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            elevation: 0,
          ),
          icon: Icon(isUsage ? Icons.check_circle_rounded : Icons.lock_outline_rounded, size: 20),
          label: Text(
            isUsage ? 'Akses Penggunaan Diberikan ✔' : 'Berikan Akses Penggunaan',
          ),
        ),
      );
    } else {
      // Screen 4: Overlay & Finish Flow
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Action button 1: Secondary Overlay trigger
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            height: 56,
            child: OutlinedButton.icon(
              onPressed: () {
                ref.read(permissionStateProvider.notifier).grantOverlay();
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: isOverlay ? const Color(0xFFE8F7EC) : Colors.white.withValues(alpha: 0.8),
                foregroundColor: isOverlay ? const Color(0xFF0D9488) : const Color(0xFF0F172A),
                side: BorderSide(
                  color: isOverlay ? const Color(0xFF10B981) : const Color(0xFFDCDCE5),
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 0,
              ),
              icon: Icon(isOverlay ? Icons.check_circle_rounded : Icons.layers_outlined, size: 20),
              label: Text(
                isOverlay ? 'Izin Hamparan Diberikan ✔' : 'Berikan Izin Hamparan',
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Action button 2: Primary routing Finish
          ElevatedButton(
            onPressed: () async {
              try {
                final isar = ref.read(isarProvider);
                final profile = await isar.userProfiles.get(1);
                if (profile != null) {
                  profile.isOnboardingCompleted = true;
                  await isar.writeTxn(() async {
                    await isar.userProfiles.put(profile);
                  });
                }
              } catch (e) {
                debugPrint('DR_DOOM_ERROR: Failed to save onboarding completed status: $e');
              }
              if (context.mounted) {
                context.go('/dashboard');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4A4CBE),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
              elevation: 0,
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Mulai Perjalanan Saya'),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward_rounded, size: 20),
              ],
            ),
          ),
        ],
      );
    }
  }
}
