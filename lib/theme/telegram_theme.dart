import 'package:flutter/material.dart';

class TelegramTheme {
  // Telegram Brand Colors
  static const Color primaryBlue = Color(0xFF2481CC);
  static const Color telegramLightBlue = Color(0xFF2AABEE);
  static const Color darkBackground = Color(0xFF1D2733);
  static const Color darkHeader = Color(0xFF212D3B);
  static const Color darkSurface = Color(0xFF17212B);
  static const Color darkBubbleOutgoing = Color(0xFF2B5278);
  static const Color darkBubbleIncoming = Color(0xFF182533);
  
  static const Color lightBackground = Color(0xFFF2F2F2);
  static const Color lightHeader = Color(0xFF527DAA);
  static const Color lightBubbleOutgoing = Color(0xFFE3F1FC);
  static const Color lightBubbleIncoming = Colors.white;

  static const Color onlineGreen = Color(0xFF40C463);
  static const Color unreadBlue = Color(0xFF3390EC);
  static const Color pinnedColor = Color(0xFF8E99A2);

  // Light ThemeData
  static ThemeData lightTheme(Color primaryColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: lightBackground,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        secondary: telegramLightBlue,
        surface: Colors.white,
        onSurface: Colors.black87,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.white,
      ),
      dividerColor: Colors.black12,
    );
  }

  // Dark ThemeData
  static ThemeData darkTheme(Color primaryColor) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        secondary: telegramLightBlue,
        surface: darkSurface,
        onSurface: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: darkHeader,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: darkSurface,
      ),
      dividerColor: Colors.white12,
    );
  }
}
