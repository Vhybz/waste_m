
import 'package:cjt_scan/utils/app_colors.dart';
import 'package:flutter/material.dart';

const double kAppCornerRadius = 24.0;

class AppTheme {
  // --- LIGHT THEME ---
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: const Color(0xFFFBFBFE),
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: const Color(0xFFFBFBFE),
    
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87, letterSpacing: -0.5),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
      bodyMedium: TextStyle(color: Colors.black54, height: 1.5),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: true,
      iconTheme: IconThemeData(color: AppColors.primary),
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5F6FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(kAppCornerRadius), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kAppCornerRadius), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      labelStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kAppCornerRadius), side: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kAppCornerRadius)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );

  // --- DARK THEME ---
  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: const Color(0xFF121212), // Deep dark background
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: const Color(0xFF121212),
    
    // ENSURING ALL TEXT IS WHITE/LIGHT
    textTheme: const TextTheme(
      headlineMedium: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: -0.5),
      titleLarge: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70, height: 1.5),
      bodyLarge: TextStyle(color: Colors.white),
      titleMedium: TextStyle(color: Colors.white),
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E), // Slightly lighter dark for appbar
      elevation: 0,
      scrolledUnderElevation: 2,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2C), // Dark tonal input
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(kAppCornerRadius), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(kAppCornerRadius), borderSide: const BorderSide(color: AppColors.primary, width: 1.5)),
      labelStyle: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w500),
      hintStyle: const TextStyle(color: Colors.white38),
    ),

    cardTheme: CardThemeData(
      elevation: 0,
      color: const Color(0xFF1E1E1E), // Tonal surface for cards
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kAppCornerRadius), side: BorderSide(color: Colors.white.withValues(alpha: 0.05))),
    ),

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 18),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kAppCornerRadius)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  );
}
