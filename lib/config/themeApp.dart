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
      surface: Colors.grey[200]!,
      onSurface: Colors.black,
    ),
  );
}
