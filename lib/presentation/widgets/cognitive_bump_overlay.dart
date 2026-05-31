import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class CognitiveBumpOverlay extends StatefulWidget {
  final VoidCallback onDismiss;

  const CognitiveBumpOverlay({
    super.key,
    required this.onDismiss,
  });

  @override
  State<CognitiveBumpOverlay> createState() => _CognitiveBumpOverlayState();
}

class _CognitiveBumpOverlayState extends State<CognitiveBumpOverlay> {
  late int _num1;
  late int _num2;
  late int _correctAnswer;
  final TextEditingController _answerController = TextEditingController();
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _generateChallenge();
  }

  void _generateChallenge({bool clearError = true}) {
    final random = Random();
    // Two-digit number (15 to 89)
    _num1 = 15 + random.nextInt(75);
    // Single-digit number (3 to 9)
    _num2 = 3 + random.nextInt(7);
    _correctAnswer = _num1 + _num2;
    _answerController.clear();
    if (clearError) {
      _errorMessage = null;
    }
  }

  void _handleSubmit() {
    final input = _answerController.text.trim();
    if (input.isEmpty) {
      setState(() {
        _errorMessage = 'Jawaban tidak boleh kosong';
      });
      return;
    }

    final parsedAnswer = int.tryParse(input);
    if (parsedAnswer == _correctAnswer) {
      // Success! Triggers the dismiss callback to close the overlay
      widget.onDismiss();
    } else {
      setState(() {
        _errorMessage = 'Jawaban salah, coba latih fokus Anda kembali!';
        // Regenerate on failure to prevent brute forcing easily
        _generateChallenge(clearError: false);
      });
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: Colors.black.withValues(alpha: 0.7),
        body: Stack(
          children: [
            // Glassmorphism Blur Effect
            Positioned.fill(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: const SizedBox.shrink(),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: (theme.colorScheme.brightness == Brightness.dark
                              ? AppColors.doomRedDark
                              : AppColors.doomRedLight)
                          .withValues(alpha: 0.3),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: (theme.colorScheme.brightness == Brightness.dark
                                ? AppColors.doomRedDark
                                : AppColors.doomRedLight)
                            .withValues(alpha: 0.15),
                        blurRadius: 30,
                        spreadRadius: 5,
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Red Warning Icon
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: (theme.colorScheme.brightness == Brightness.dark
                                  ? AppColors.doomRedDark
                                  : AppColors.doomRedLight)
                              .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.warning_amber_rounded,
                          color: theme.colorScheme.brightness == Brightness.dark
                              ? AppColors.doomRedDark
                              : AppColors.doomRedLight,
                          size: 48,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'DOOMSCROLLING TERDETEKSI',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.brightness == Brightness.dark
                              ? AppColors.doomRedDark
                              : AppColors.doomRedLight,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Sistem mendeteksi tingkat scrolling yang sangat berisiko. Pecahkan tantangan kesadaran ini untuk membuka layar Anda.',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 32),
                      // Challenge Equation Box
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 32,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.brightness == Brightness.light
                              ? Colors.grey.shade100
                              : Colors.black.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: theme.colorScheme.brightness == Brightness.light
                                ? Colors.grey.shade300
                                : Colors.grey.shade800,
                          ),
                        ),
                        child: Text(
                          '$_num1  +  $_num2  =  ?',
                          style: theme.textTheme.displayLarge?.copyWith(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Answer Input
                      TextField(
                        controller: _answerController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Masukkan jawaban Anda',
                          errorText: _errorMessage,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 20,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide(
                              color: theme.colorScheme.brightness == Brightness.dark
                                  ? AppColors.doomRedDark
                                  : AppColors.doomRedLight,
                              width: 2,
                            ),
                          ),
                        ),
                        onSubmitted: (_) => _handleSubmit(),
                      ),
                      const SizedBox(height: 32),
                      // Submit & Regenerate buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: _generateChallenge,
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(0, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('Acak Ulang'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _handleSubmit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.colorScheme.brightness == Brightness.dark
                                    ? AppColors.doomRedDark
                                    : AppColors.doomRedLight,
                                foregroundColor: theme.colorScheme.brightness == Brightness.dark
                                    ? const Color(0xFF080B14)
                                    : Colors.white,
                                minimumSize: const Size(0, 56),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Konfirmasi',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
