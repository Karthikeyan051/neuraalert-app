import 'package:flutter/material.dart';

class AppTheme {
  // Light palette
  static const Color lightBg = Color(0xFFF5F9FF);
  static const Color lightPrimary = Color(0xFF1565C0);
  static const Color lightSecondary = Color(0xFF2196F3);
  static const Color lightAmber = Color(0xFFFF8F00);
  static const Color lightText = Color(0xFF0A1628);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCard = Color(0xFFE8F0FE);

  // Dark palette
  static const Color darkBg = Color(0xFF060B14);
  static const Color darkNeon = Color(0xFF00D4FF);
  static const Color darkAmber = Color(0xFFFFB300);
  static const Color darkText = Color(0xFFE8F4FF);
  static const Color darkSurface = Color(0xFF0D1E3A);
  static const Color darkCard = Color(0xFF142035);

  // Alert screen (always dark)
  static const Color alertBg = Color(0xFF0D1E3A);
  static const Color alertNeon = Color(0xFF00D4FF);

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: lightPrimary,
        secondary: lightSecondary,
        tertiary: lightAmber,
        surface: lightSurface,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: lightText,
      ),
      scaffoldBackgroundColor: lightBg,
      cardColor: lightCard,
      appBarTheme: AppBarTheme(
        backgroundColor: lightBg,
        foregroundColor: lightText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: lightText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: lightSurface,
        indicatorColor: lightPrimary.withAlpha(30),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: lightText),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: lightPrimary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: lightPrimary,
          side: BorderSide(color: lightPrimary),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: lightPrimary, width: 2),
        ),
      ),
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: darkNeon,
        secondary: darkAmber,
        surface: darkSurface,
        onPrimary: darkBg,
        onSecondary: darkBg,
        onSurface: darkText,
      ),
      scaffoldBackgroundColor: darkBg,
      cardColor: darkCard,
      appBarTheme: AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: darkText,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w700,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: darkSurface,
        indicatorColor: darkNeon.withAlpha(40),
        labelTextStyle: WidgetStateProperty.all(
          TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: darkText),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: darkNeon,
          foregroundColor: darkBg,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: darkNeon,
          side: BorderSide(color: darkNeon),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          minimumSize: const Size.fromHeight(52),
          textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: darkNeon, width: 2),
        ),
      ),
    );
  }
}
