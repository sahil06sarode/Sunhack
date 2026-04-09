import 'package:flutter/material.dart';

class SovereignPalette {
  static const Color lightBackground = Color(0xFFF8F8F6);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightTextMain = Color(0xFF111827);
  static const Color lightTextSecondary = Color(0xFF374151);
  static const Color lightTextMuted = Color(0xFF6B7280);
  static const Color lightPlaceholder = Color(0xFF4B5563);

  static const Color darkBackground = Color(0xFF0D131F);
  static const Color darkSurface = Color(0xFF1C2331);
  static const Color darkInput = Color(0xFF162032);
  static const Color darkBorder = Color(0xFF2E3A50);
  static const Color darkNavBackground = Color(0xFF0F172A);
  static const Color darkTextMain = Color(0xFFF8FAFC);
  static const Color darkTextMuted = Color(0xFF94A3B8);
  static const Color darkTitleMuted = Color(0xFFD1D5DB);
  static const Color darkPlaceholder = Color(0xFF9CA3AF);
  static const Color darkActive = Color(0xFF7DD3FC);
}

class SovereignTextStyles {
  static const TextStyle brandLight = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.7,
    color: SovereignPalette.lightTextMain,
  );

  static const TextStyle brandDark = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 3.6,
    color: SovereignPalette.darkTextMain,
  );

  static const TextStyle cardTitleLight = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: SovereignPalette.lightTextMain,
  );

  static const TextStyle cardTitleDark = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 1.2,
    color: SovereignPalette.darkTitleMuted,
  );

  static const TextStyle cardBodyLight = TextStyle(
    fontSize: 40 * 0.42,
    height: 1.55,
    color: SovereignPalette.lightTextSecondary,
  );

  static const TextStyle cardBodyDark = TextStyle(
    fontSize: 40 * 0.42,
    height: 1.35,
    fontWeight: FontWeight.w500,
    color: SovereignPalette.darkTextMain,
  );

  static const TextStyle askLightInput = TextStyle(
    fontSize: 32 * 0.625,
    color: Color(0xFF1F2937),
  );

  static const TextStyle askLightPlaceholder = TextStyle(
    fontSize: 32 * 0.625,
    color: SovereignPalette.lightPlaceholder,
  );

  static const TextStyle askDarkInput = TextStyle(
    fontSize: 18,
    color: SovereignPalette.darkTextMain,
  );

  static const TextStyle askDarkPlaceholder = TextStyle(
    fontSize: 18,
    color: SovereignPalette.darkPlaceholder,
  );
}

class SovereignAppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: SovereignPalette.lightBackground,
      colorScheme: ColorScheme.fromSeed(seedColor: SovereignPalette.lightTextMain),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: SovereignPalette.darkBackground,
      colorScheme: ColorScheme.fromSeed(
        seedColor: SovereignPalette.darkActive,
        brightness: Brightness.dark,
      ),
    );
  }
}
