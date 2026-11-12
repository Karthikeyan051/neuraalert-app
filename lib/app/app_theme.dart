import 'package:flutter/material.dart';

/// NeuraAlert Design System — "Calm Clinical"
/// No neon. No decorative blobs. Deep teal + warm off-white (light) / warm charcoal (dark).
/// 8dp spacing grid. 12dp–16dp corner radius. Generous breathing room.
class AppTheme {
  static const String fontFamily = 'NotoSans';
  static const List<String> fontFallback = ['NotoSansTamil'];

  // ── Light Palette ────────────────────────────────────────────────
  static const Color lightBg      = Color(0xFFFAF8F4); // warm off-white
  static const Color lightSurface = Color(0xFFFFFFFF); // cards, sheets, dock
  static const Color lightText    = Color(0xFF1B1B1B); // primary text
  static const Color lightTextSub = Color(0xFF4A4A4A); // secondary text
  static const Color lightDivider = Color(0xFFE0DDD7); // 1dp dividers
  static const Color lightCard    = Color(0xFFF4F2EE); // subtle card bg

  static const Color primary      = Color(0xFF0B5D6B); // deep teal
  static const Color onPrimary    = Color(0xFFFFFFFF);
  static const Color primaryLight = Color(0xFFE0F2F4); // teal 10% — chip bg
  static const Color primaryMid   = Color(0xFF4DB6C5); // teal mid — dark mode primary

  static const Color success      = Color(0xFF1E7B4F); // taken
  static const Color successLight = Color(0xFFE6F4EC);
  static const Color warning      = Color(0xFF9A5B00); // snooze / food
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color error        = Color(0xFFB3261E); // missed / delete
  static const Color errorLight   = Color(0xFFFCE8E6);

  // Alert screen — always dark regardless of system theme
  static const Color alertBg      = Color(0xFF12262B);
  static const Color alertSurface = Color(0xFF1A3540);
  static const Color alertText    = Color(0xFFFFFFFF);
  static const Color alertTextSub = Color(0xFFB0C4CB);
  static const Color alertPrimary = Color(0xFF4DB6C5);

  // ── Dark Palette ─────────────────────────────────────────────────
  static const Color darkBg      = Color(0xFF111210);
  static const Color darkSurface = Color(0xFF1C1B19);
  static const Color darkCard    = Color(0xFF242321);
  static const Color darkText    = Color(0xFFF0EDE8);
  static const Color darkTextSub = Color(0xFFA09D98);
  static const Color darkDivider = Color(0xFF2E2D2A);

  // ── Spacing & Geometry ───────────────────────────────────────────
  static const double spaceXS  = 4.0;
  static const double spaceSM  = 8.0;
  static const double spaceMD  = 16.0;
  static const double spaceLG  = 24.0;
  static const double spaceXL  = 32.0;
  static const double spaceXXL = 48.0;

  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 24.0;

  static const double touchTarget = 56.0;

  // ── Theme-aware color helpers ────────────────────────────────────
  static bool isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color bg(BuildContext context) =>
      isDark(context) ? darkBg : lightBg;

  static Color surface(BuildContext context) =>
      isDark(context) ? darkSurface : lightSurface;

  static Color card(BuildContext context) =>
      isDark(context) ? darkCard : lightCard;

  static Color text(BuildContext context) =>
      isDark(context) ? darkText : lightText;

  static Color textSub(BuildContext context) =>
      isDark(context) ? darkTextSub : lightTextSub;

  static Color divider(BuildContext context) =>
      isDark(context) ? darkDivider : lightDivider;

  static Color primaryOf(BuildContext context) =>
      isDark(context) ? primaryMid : primary;

  static Color chipBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF18333A) : primaryLight;

  static Color warningBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF332613) : warningLight;

  static Color warningFg(BuildContext context) =>
      isDark(context) ? const Color(0xFFF2B866) : warning;

  static Color successBg(BuildContext context) =>
      isDark(context) ? const Color(0xFF153325) : successLight;

  static Color successFg(BuildContext context) =>
      isDark(context) ? const Color(0xFF6DD49E) : success;

  // ── Light Theme ──────────────────────────────────────────────────
  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: fontFamily,
    );
    return base.copyWith(
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: primaryMid,
        onSecondary: onPrimary,
        surface: lightSurface,
        onSurface: lightText,
        surfaceContainerHighest: lightCard,
        error: error,
        onError: Colors.white,
      ),
      scaffoldBackgroundColor: lightBg,
      dividerColor: lightDivider,
      dividerTheme: const DividerThemeData(
        color: lightDivider,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: lightSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
          side: const BorderSide(color: lightDivider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: lightBg,
        foregroundColor: lightText,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFallback,
          color: lightText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: lightText, size: 24),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: onPrimary,
          disabledBackgroundColor: lightDivider,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          minimumSize: const Size.fromHeight(touchTarget),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFallback,
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: spaceMD),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primary,
          side: const BorderSide(color: primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          minimumSize: const Size.fromHeight(touchTarget),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFallback,
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.1,
          ),
          padding: const EdgeInsets.symmetric(horizontal: spaceMD),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          minimumSize: const Size(44, 44),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFallback,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: lightCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: spaceMD, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: lightDivider, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: lightDivider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        hintStyle: const TextStyle(color: Color(0xFF8C8A85), fontSize: 16),
        labelStyle: const TextStyle(color: lightTextSub, fontSize: 14),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: lightCard,
        selectedColor: primaryLight,
        secondarySelectedColor: primaryLight,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        secondaryLabelStyle: const TextStyle(
            color: primary, fontSize: 14, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSM),
          side: const BorderSide(color: lightDivider),
        ),
        checkmarkColor: primary,
        showCheckmark: true,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? primary : Colors.white),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? primaryLight : lightDivider),
        trackOutlineColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? primary : lightDivider),
      ),
      listTileTheme: const ListTileThemeData(
        minVerticalPadding: 12,
        contentPadding: EdgeInsets.symmetric(horizontal: spaceMD),
        style: ListTileStyle.list,
      ),
      textTheme: _textTheme(lightText, lightTextSub),
    );
  }

  // ── Dark Theme ───────────────────────────────────────────────────
  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      fontFamily: fontFamily,
    );
    return base.copyWith(
      colorScheme: const ColorScheme.dark(
        primary: primaryMid,
        onPrimary: darkBg,
        secondary: primaryMid,
        onSecondary: darkBg,
        surface: darkSurface,
        onSurface: darkText,
        surfaceContainerHighest: darkCard,
        error: Color(0xFFCF6679),
        onError: Colors.black,
      ),
      scaffoldBackgroundColor: darkBg,
      dividerColor: darkDivider,
      dividerTheme: const DividerThemeData(
        color: darkDivider,
        thickness: 1,
        space: 1,
      ),
      cardTheme: CardThemeData(
        color: darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusLG),
          side: const BorderSide(color: darkDivider, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkBg,
        foregroundColor: darkText,
        elevation: 0,
        scrolledUnderElevation: 1,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        titleTextStyle: TextStyle(
          fontFamily: fontFamily,
          fontFamilyFallback: fontFallback,
          color: darkText,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.3,
        ),
        iconTheme: IconThemeData(color: darkText, size: 24),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryMid,
          foregroundColor: darkBg,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          minimumSize: const Size.fromHeight(touchTarget),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFallback,
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryMid,
          side: const BorderSide(color: primaryMid, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          minimumSize: const Size.fromHeight(touchTarget),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFallback,
            fontSize: 17,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryMid,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radiusMD),
          ),
          minimumSize: const Size(44, 44),
          textStyle: const TextStyle(
            fontFamily: fontFamily,
            fontFamilyFallback: fontFallback,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: spaceMD, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: darkDivider, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: darkDivider, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(radiusMD),
          borderSide: const BorderSide(color: primaryMid, width: 2),
        ),
        hintStyle: TextStyle(color: Colors.white.withAlpha(90), fontSize: 16),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: darkCard,
        selectedColor: const Color(0xFF1A3540),
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusSM),
          side: const BorderSide(color: darkDivider),
        ),
        checkmarkColor: primaryMid,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? primaryMid : Colors.grey),
        trackColor: WidgetStateProperty.resolveWith((s) =>
            s.contains(WidgetState.selected) ? const Color(0xFF1A3540) : darkCard),
      ),
      textTheme: _textTheme(darkText, darkTextSub),
    );
  }

  static TextTheme _textTheme(Color primary, Color secondary) {
    TextStyle base(double size, FontWeight weight, Color color,
        {double? letterSpacing, double? height}) {
      return TextStyle(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFallback,
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
        height: height,
      );
    }

    return TextTheme(
      displayLarge:   base(32, FontWeight.w700, primary, letterSpacing: -0.5),
      displayMedium:  base(28, FontWeight.w700, primary, letterSpacing: -0.4),
      displaySmall:   base(24, FontWeight.w600, primary, letterSpacing: -0.3),
      headlineMedium: base(22, FontWeight.w600, primary, letterSpacing: -0.2),
      headlineSmall:  base(20, FontWeight.w600, primary, letterSpacing: -0.2),
      titleLarge:     base(18, FontWeight.w600, primary),
      titleMedium:    base(16, FontWeight.w500, primary),
      titleSmall:     base(14, FontWeight.w500, primary),
      bodyLarge:      base(18, FontWeight.w400, primary, height: 1.5),
      bodyMedium:     base(16, FontWeight.w400, primary, height: 1.5),
      bodySmall:      base(14, FontWeight.w400, secondary, height: 1.4),
      labelLarge:     base(14, FontWeight.w500, primary, letterSpacing: 0.1),
      labelMedium:    base(12, FontWeight.w500, secondary, letterSpacing: 0.5),
      labelSmall:     base(11, FontWeight.w500, secondary, letterSpacing: 0.5),
    );
  }
}
