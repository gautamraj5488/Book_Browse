import 'package:flutter/material.dart';

class AppColors {
  static Color get primaryColor => _getColor(
      light: const Color(0xFF2196F3), // Lighter Blue for light mode
      dark: const Color(0xFF90CAF9)); // Lighter Blue for dark mode
  static Color get secondaryColor => _getColor(
      light: const Color(0xFF03A9F4), // Lighter Cyan for light mode
      dark: const Color(0xFF81D4FA)); // Lighter Cyan for dark mode
  static Color get accentColor => _getColor(
      light: const Color(0xFFFFC107), // Amber for light mode
      dark: const Color(0xFFFFC107)); // Amber for dark mode
  static Color get backgroundColor => _getColor(
      light: const Color(0xFFF1F1F1), // Light Gray for light mode
      dark: const Color(0xFF121212)); // Dark Gray for dark mode
  static Color get textColor => _getColor(
      light: const Color(0xFF333333), // Dark Gray for text in light mode
      dark: const Color(0xFFFFFFFF)); // White text for dark mode
  static Color get whiteColor => Colors.white;
  static Color get errorColor => Colors.red;

  // App bar and button colors
  static Color get appBarColor => _getColor(
      light: const Color(0xFF1565C0), // Deep Blue for light mode
      dark: const Color(0xFF1E3A8A)); // Dark Blue for dark mode
  static Color get appBarTextColor => Colors.white; // White text for app bar
  static Color get buttonColor => _getColor(
      light: const Color(0xFF03A9F4), // Cyan (Bright) for light mode
      dark: const Color(0xFF039BE5)); // Darker Cyan for dark mode
  static Color get buttonTextColor => Colors.white; // White text for buttons

  // Additional utility colors
  static Color get cardColor => _getColor(
      light: const Color(0xFFF5F5F5), // Light Gray for cards in light mode
      dark: const Color(0xFF333333)); // Darker Gray for cards in dark mode
  static Color get darkCardColor => _getColor(
      light: const Color(0xFFF5F5F5), // Light Gray for cards in light mode
      dark: const Color(0xFF333333)); // Darker Gray for cards in dark mode
  static Color get borderColor => const Color(0xFFBDBDBD); // Gray border color
  static Color get shadowColor => const Color(0x1A000000); // Semi-transparent shadow
  static Color get successColor => const Color(0xFF388E3C); // Green for success messages
  static Color get warningColor => const Color(0xFFF57C00); // Orange for warnings
  static Color get infoColor => const Color(0xFF0288D1); // Blue for informational messages

  // Helper method to get color based on theme
  static Color _getColor({required Color light, required Color dark}) {
    return WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? dark : light;
  }
}
