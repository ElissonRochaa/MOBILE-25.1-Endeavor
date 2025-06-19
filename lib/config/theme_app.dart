import 'package:flutter/material.dart';

class ThemeApp {
  static final theme = ThemeData(
    colorScheme: ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF03045E),
      onPrimary: Colors.white,
      secondary: Color(0xFF0077B6),
      onSecondary: Colors.black,
      tertiary: Color(0xFF00B4D8),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFCAF0F8),
      error: Colors.red,
      onError: Colors.white,
      surface: Colors.white,
      onSurface: Colors.black,
    ),
  );

  static final darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      brightness: Brightness.dark,
      primary: Color(0xFF0077B6),
      onPrimary: Colors.white,
      secondary: Color(0xFF00B4D8),
      onSecondary: Colors.black,
      tertiary: Color(0xFF2F2D2D),
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFCAF0F8),
      error: Color(0xFFEF476F),
      onError: Colors.white,
      surface: Color(0xFF2F2D2D),
      onSurface: Colors.white,
    ),
  );

}
