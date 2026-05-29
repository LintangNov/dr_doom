import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Calming Theme Colors (Mindfulness)
  static const Color primaryLight = Color(0xFF6366F1); // Indigo Indigo-500
  static const Color primaryDark = Color(0xFF818CF8);  // Indigo Indigo-400

  // Secondary Focus/Safety Colors
  static const Color secondaryLight = Color(0xFF0D9488); // Teal Teal-600
  static const Color secondaryDark = Color(0xFF2DD4BF);  // Teal Teal-400

  // Neutral Backgrounds
  static const Color backgroundLight = Color(0xFFF8FAFC); // Slate Slate-50
  static const Color backgroundDark = Color(0xFF0F172A);  // Slate Slate-900 (Deep, modern dark)

  // Surface Card Colors
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);   // Slate Slate-800

  // Alerts & Doomscrolling Warning Indicators
  static const Color doomRedLight = Color(0xFFEF4444);  // Red-500 (Urgency/Doom)
  static const Color doomRedDark = Color(0xFFF87171);   // Red-400

  static const Color doomOrangeLight = Color(0xFFF97316); // Orange-500 (Warning)
  static const Color doomOrangeDark = Color(0xFFFB923C);  // Orange-400

  static const Color successGreenLight = Color(0xFF10B981); // Emerald-500 (Good status/Calm)
  static const Color successGreenDark = Color(0xFF34D399);  // Emerald-400

  // Text Colors
  static const Color textPrimaryLight = Color(0xFF0F172A); // Slate-900
  static const Color textPrimaryDark = Color(0xFFF8FAFC);  // Slate-50

  static const Color textSecondaryLight = Color(0xFF64748B); // Slate-500
  static const Color textSecondaryDark = Color(0xFF94A3B8);  // Slate-400

  // Custom Gradient Palettes (Premium Aesthetic)
  static const List<Color> doomGradient = [
    Color(0xFFEF4444),
    Color(0xFFF97316),
  ];

  static const List<Color> calmGradient = [
    Color(0xFF6366F1),
    Color(0xFF0D9488),
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
        background: backgroundLight,
        surface: surfaceLight,
        error: doomRedLight,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onBackground: textPrimaryLight,
        onSurface: textPrimaryLight,
      ),
      cardTheme: const CardTheme(
        color: surfaceLight,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textPrimaryLight, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimaryLight),
        bodyMedium: TextStyle(color: textSecondaryLight),
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
        background: backgroundDark,
        surface: surfaceDark,
        error: doomRedDark,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onBackground: textPrimaryDark,
        onSurface: textPrimaryDark,
      ),
      cardTheme: const CardTheme(
        color: surfaceDark,
        elevation: 0,
        margin: EdgeInsets.zero,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(color: textPrimaryDark, fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: textPrimaryDark),
        bodyMedium: TextStyle(color: textSecondaryDark),
      ),
    );
  }
}
