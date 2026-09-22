import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static ThemeData theme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: Colors.white,
    // Default font
    fontFamily: GoogleFonts.outfit().fontFamily,
    

    textTheme: TextTheme(
      // Headlines
      headlineLarge: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),

      headlineMedium: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),

      headlineSmall: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),

      // Titles
      titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),

      titleMedium: TextStyle(fontSize: 18),

      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),

      // Body
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),

      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),

      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),

      // Labels
      labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w300),

      labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),

      labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
    ),
  );
}
