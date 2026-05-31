import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();

  // Primary Calming Theme Colors (Mindfulness)
  static const Color primaryLight = Color(0xFF9FA1FF); // Pastel Indigo/Violet (#9FA1FF)
  static const Color primaryDark = Color(0xFF8B8DFF);  // Vibrant Lavender (#8B8DFF)

  // Secondary Focus/Safety Colors
  static const Color secondaryLight = Color(0xFFB5BAFF); // Soft Periwinkle (#B5BAFF)
  static const Color secondaryDark = Color(0xFFA1A6FF);  // Electric Periwinkle (#A1A6FF)

  // Tertiary Highlight Colors
  static const Color tertiaryLight = Color(0xFFAEE2FF); // Baby/Ice Blue (#AEE2FF)
  static const Color tertiaryDark = Color(0xFF7AD7FF);  // Soft Neon Cyan (#7AD7FF)

  // Neutral Backgrounds & Cards
  static const Color neutralLight = Color(0xFF78767D); // Cool Neutral Gray (#78767D)
  static const Color neutralDark = Color(0xFF0F172A);  // Slate Dark Black (#0F172A)

  // Actual System Colors for scaffold and cards
  static const Color backgroundLight = Color(0xFFF4F3F7); // Sleek Light Lavender-Grey Scaffold background
  static const Color backgroundDark = Color(0xFF080B14);  // Ultra-Deep Slate Blue scaffold background

  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure White cards
  static const Color surfaceDark = Color(0xFF0F172A);  // Neutral slate card background

  // Alerts & Doomscrolling Warning Indicators (Kept custom/premium for contrast)
  static const Color doomRedLight = Color(0xFFEF4444);  // Red-500
  static const Color doomRedDark = Color(0xFFF87171);   // Red-400

  static const Color doomOrangeLight = Color(0xFFF97316); // Orange-500
  static const Color doomOrangeDark = Color(0xFFFB923C);  // Orange-400

  static const Color successGreenLight = Color(0xFF10B981); // Emerald-500
  static const Color successGreenDark = Color(0xFF34D399);  // Emerald-400

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A); // Deep Slate
  static const Color textPrimaryDark = Color(0xFFF8FAFC);  // Off-white

  static const Color textSecondaryLight = Color(0xFF5C5A69); // Medium cool gray
  static const Color textSecondaryDark = Color(0xFF94A3B8);  // Cool slate gray

  // Custom Gradient Palettes (Premium Aesthetic)
  static const List<Color> doomGradient = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
  ];

  static const List<Color> calmGradientLight = [
    Color(0xFF9FA1FF),
    Color(0xFFB5BAFF),
  ];

  static const List<Color> calmGradientDark = [
    Color(0xFF8B8DFF),
    Color(0xFFA1A6FF),
  ];

  // Helper Methods to generate Theme Data
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryLight,
      scaffoldBackgroundColor: backgroundLight,
      colorScheme: const ColorScheme.light(
        primary: primaryLight,
        secondary: secondaryLight,
        tertiary: tertiaryLight,
        surface: surfaceLight,
        error: doomRedLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: textPrimaryLight,
      ),
      cardTheme: const CardThemeData(
        color: surfaceLight,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(
          color: textPrimaryLight,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.manrope(
          color: textPrimaryLight,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.manrope(
          color: textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.manrope(
          color: textPrimaryLight,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.manrope(
          color: textPrimaryLight,
        ),
        bodyMedium: GoogleFonts.manrope(
          color: textSecondaryLight,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          color: textSecondaryLight,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          color: textSecondaryLight,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A4CBE), // Vibrant solid primary indigo/violet button
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryLight,
          side: const BorderSide(color: Color(0xFFDCDCE5), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFFF6F5FA),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.manrope(color: textSecondaryLight),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E2EC)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE2E2EC)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryLight, width: 2),
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryDark,
      scaffoldBackgroundColor: backgroundDark,
      colorScheme: const ColorScheme.dark(
        primary: primaryDark,
        secondary: secondaryDark,
        tertiary: tertiaryDark,
        surface: surfaceDark,
        error: doomRedDark,
        onPrimary: Color(0xFF080B14),
        onSecondary: Color(0xFF080B14),
        onSurface: textPrimaryDark,
      ),
      cardTheme: const CardThemeData(
        color: surfaceDark,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24)),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.manrope(
          color: textPrimaryDark,
          fontWeight: FontWeight.bold,
          letterSpacing: -1.0,
        ),
        displayMedium: GoogleFonts.manrope(
          color: textPrimaryDark,
          fontWeight: FontWeight.bold,
        ),
        titleLarge: GoogleFonts.manrope(
          color: textPrimaryDark,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: GoogleFonts.manrope(
          color: textPrimaryDark,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: GoogleFonts.manrope(
          color: textPrimaryDark,
        ),
        bodyMedium: GoogleFonts.manrope(
          color: textSecondaryDark,
        ),
        labelLarge: GoogleFonts.plusJakartaSans(
          color: textSecondaryDark,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: GoogleFonts.plusJakartaSans(
          color: textSecondaryDark,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryDark, // Electric periwinkle/lavender button
          foregroundColor: const Color(0xFF080B14),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryDark,
          side: const BorderSide(color: Color(0xFF334155), width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: GoogleFonts.manrope(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: GoogleFonts.manrope(color: textSecondaryDark),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF334155)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: primaryDark, width: 2),
        ),
      ),
    );
  }
}
