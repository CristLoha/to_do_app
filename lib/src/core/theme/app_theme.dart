import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const _primaryColor = Color(0xFF6C63FF);
  static const _backgroundColorLight = Color(0xFFF5F5F7);
  static const _cardColorLight = Color(0xFFFFFFFF);
  static const _textColorLight = Color(0xFF1C1C1E);

  static const _backgroundColorDark = Color(0xFF1C1C1E);
  static const _cardColorDark = Color(0xFF2C2C2E);
  static const _textColorDark = Color(0xFFF5F5F7);

  static final ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.light,
      primary: _primaryColor,

      surface: _backgroundColorLight,
    ),
    appBarTheme: AppBarTheme(
      foregroundColor: _textColorLight,
      titleTextStyle: GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: _textColorLight,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: _cardColorLight,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.light().textTheme.apply(bodyColor: _textColorLight),
    ),
    scaffoldBackgroundColor: _backgroundColorLight,
    useMaterial3: true,
  );

  static final ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: _primaryColor,
      brightness: Brightness.dark,
      primary: _primaryColor,
      // FIX: Replaced deprecated 'background' with 'surface'
      surface: _backgroundColorDark,
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: _textColorDark,
      titleTextStyle: GoogleFonts.inter(
        fontWeight: FontWeight.bold,
        fontSize: 24,
        color: _textColorDark,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: _primaryColor,
      foregroundColor: Colors.white,
    ),
    cardTheme: CardThemeData(
      color: _cardColorDark,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    ),
    textTheme: GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme.apply(bodyColor: _textColorDark),
    ),
    scaffoldBackgroundColor: _backgroundColorDark,
    useMaterial3: true,
  );
}
