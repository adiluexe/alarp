import 'package:flutter/material.dart';

class AppTheme {
  // Define colors based on your input
  static const Color textColor = Color(0xFF080d16);
  static const Color backgroundColor = Color(0xFFf4f7fb);
  static const Color primaryColor = Color(0xFF5b8cbe);
  static const Color secondaryColor = Color(0xFFa7a4db);
  static const Color accentColor = Color(0xFF9078c9); // Tertiary
  static const Color errorColor = Color(0xFFB3261E);

  // Material 3 text scaling for mobile devices
  static ThemeData get lightTheme {
    // Create the ColorScheme
    final colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: primaryColor,
      onPrimary: Colors.white, // White text on primary is more readable
      secondary: secondaryColor,
      onSecondary: textColor,
      tertiary: accentColor,
      onTertiary: textColor,
      error: errorColor,
      onError: Colors.white,
      background: backgroundColor,
      onBackground: textColor,
      surface: Colors.white, // Use white for cards for better contrast
      onSurface: textColor,
      shadow: Colors.black.withOpacity(0.1),
    );

    // Define TextTheme with custom fonts and specific sizes
    final textTheme = TextTheme(
      // --- Headers using Chillax ---
      displayLarge: TextStyle(
        fontFamily: 'Chillax',
        fontSize: 57,
        fontWeight: FontWeight.w700, // Bold
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: TextStyle(
        fontFamily: 'Chillax',
        fontSize: 45,
        fontWeight: FontWeight.w600, // Semibold
        letterSpacing: 0,
        height: 1.15,
      ),
      displaySmall: TextStyle(
        fontFamily: 'Chillax',
        fontSize: 36,
        fontWeight: FontWeight.w600, // Semibold
        letterSpacing: 0,
        height: 1.22,
      ),
      headlineLarge: TextStyle(
        fontFamily: 'Chillax',
        fontSize: 32,
        fontWeight: FontWeight.w700, // Bold
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: TextStyle(
        fontFamily: 'Chillax',
        fontSize: 28,
        fontWeight: FontWeight.w600, // Semibold
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: TextStyle(
        fontFamily: 'Chillax',
        fontSize: 24,
        fontWeight: FontWeight.w600, // Semibold
        letterSpacing: 0,
        height: 1.33,
      ),
      titleLarge: TextStyle(
        fontFamily: 'Chillax',
        fontSize: 22,
        fontWeight: FontWeight.w600, // Semibold
        letterSpacing: 0,
        height: 1.27,
      ),

      // --- Body text using Satoshi ---
      titleMedium: TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 16,
        fontWeight: FontWeight.w500, // Medium
        letterSpacing: 0.15,
        height: 1.5,
      ),
      titleSmall: TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 14,
        fontWeight: FontWeight.w500, // Medium
        letterSpacing: 0.1,
        height: 1.43,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 16,
        fontWeight: FontWeight.w400, // Regular
        letterSpacing: 0.5,
        height: 1.5,
      ),
      bodyMedium: TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 14,
        fontWeight: FontWeight.w400, // Regular
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 12,
        fontWeight: FontWeight.w400, // Regular
        letterSpacing: 0.4,
        height: 1.33,
        color: textColor.withOpacity(0.7),
      ),

      // --- Button text ---
      labelLarge: TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 14,
        fontWeight: FontWeight.w700, // Bold
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 12,
        fontWeight: FontWeight.w500, // Medium
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: TextStyle(
        fontFamily: 'Satoshi',
        fontSize: 11,
        fontWeight: FontWeight.w500, // Medium
        letterSpacing: 0.5,
        height: 1.45,
      ),
    ).apply(bodyColor: textColor, displayColor: textColor);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: backgroundColor,
      fontFamily: 'Satoshi',
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: colorScheme.onPrimary,
        elevation: 0,
        titleTextStyle: textTheme.headlineSmall?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: colorScheme.onPrimary,
          textStyle: textTheme.labelLarge,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      ),
      sliderTheme: SliderThemeData(
        activeTrackColor: primaryColor,
        inactiveTrackColor: primaryColor.withOpacity(0.3),
        thumbColor: primaryColor,
        overlayColor: primaryColor.withOpacity(0.2),
      ),
    );
  }
}
