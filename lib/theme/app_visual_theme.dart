import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppVisualTheme {
  const AppVisualTheme._();

  static const Color canvas = Color(0xFFF8F7F2);
  static const Color ink = Color(0xFF1B2430);
  static const Color mutedInk = Color(0xFF5F6B7D);
  static const Color brandBlue = Color(0xFF1C4C93);
  static const Color brandCoral = Color(0xFFE76645);
  static const Color brandTeal = Color(0xFF1F8F82);
  static const Color cardStroke = Color(0xFFDDE4F0);

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFFFFF4E6),
      Color(0xFFEFF6FF),
      Color(0xFFF2FAF5),
    ],
  );

  static ThemeData lightTheme() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: brandBlue,
        brightness: Brightness.light,
        primary: brandBlue,
        secondary: brandCoral,
      ),
      scaffoldBackgroundColor: canvas,
    );

    final bodyTheme = GoogleFonts.plusJakartaSansTextTheme(base.textTheme);

    final textTheme = bodyTheme.copyWith(
      displayLarge: GoogleFonts.sora(
        fontSize: 44,
        fontWeight: FontWeight.w700,
        color: ink,
        height: 1.05,
      ),
      displaySmall: GoogleFonts.sora(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: ink,
        height: 1.08,
      ),
      headlineLarge: GoogleFonts.sora(
        fontSize: 30,
        fontWeight: FontWeight.w700,
        color: ink,
        height: 1.1,
      ),
      headlineMedium: GoogleFonts.sora(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: ink,
        height: 1.15,
      ),
      titleLarge: GoogleFonts.sora(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      titleMedium: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: ink,
        height: 1.45,
      ),
      bodyMedium: GoogleFonts.plusJakartaSans(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: mutedInk,
        height: 1.45,
      ),
      bodySmall: GoogleFonts.plusJakartaSans(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: mutedInk,
        height: 1.35,
      ),
      labelLarge: GoogleFonts.plusJakartaSans(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
    );

    return base.copyWith(
      textTheme: textTheme,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: ink,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
          side: const BorderSide(color: cardStroke),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.93),
        hintStyle: GoogleFonts.plusJakartaSans(
          color: mutedInk,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: cardStroke),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: cardStroke),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: brandBlue, width: 1.4),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: ink,
        contentTextStyle: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
