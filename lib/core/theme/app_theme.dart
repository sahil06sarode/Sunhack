import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    const seed = Color(0xFFB53318);

    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seed,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: const Color(0xFFF7F4EF),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.symmetric(vertical: 8),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        backgroundColor: Color(0xFFF7F4EF),
      ),
      navigationBarTheme: const NavigationBarThemeData(
        indicatorColor: Color(0xFFFFD8B3),
      ),
    );
  }
}
