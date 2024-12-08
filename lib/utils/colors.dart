import 'package:flutter/material.dart';

class AppColors {
  static Color get highlightColor => _getColor(
    light: Colors.red,
    dark: Colors.red);
  static Color get primaryColor => _getColor(
      light: SMAColors.primary, // Primary color
      dark: SMAColors.accent); // Accent color as the primary alternative in dark mode
  static Color get secondaryColor => _getColor(
      light: SMAColors.secondary, // Secondary color
      dark: SMAColors.secondary); // Same secondary color for dark mode
  static Color get accentColor => _getColor(
      light: SMAColors.accent, // Accent color
      dark: SMAColors.accent); // Same accent color for dark mode
  static Color get backgroundColor => _getColor(
      light: SMAColors.primaryBackground, // Light mode background
      dark: SMAColors.dark); // Dark mode background
  static Color get textColor => _getColor(
      light: SMAColors.textPrimary, // Primary text color for light mode
      dark: SMAColors.textWhite); // White text for dark mode
  static Color get whiteColor => SMAColors.white;
  static Color get errorColor => SMAColors.error;

  // App bar and button colors
  static Color get appBarColor => _getColor(
      light: SMAColors.primary, // Primary color for light mode app bar
      dark: SMAColors.dark); // Dark color for dark mode app bar
  static Color get appBarTextColor => SMAColors.textWhite; // White text for app bar
  static Color get buttonColor => _getColor(
      light: SMAColors.buttonPrimary, // Primary button color
      dark: SMAColors.buttonPrimary); // Same button color for dark mode
  static Color get buttonTextColor => SMAColors.textWhite; // White text for buttons

  // Additional utility colors
  static Color get cardColor => _getColor(
      light: SMAColors.lightContainer, // Light container for cards in light mode
      dark: SMAColors.darkContainer); // Dark container for cards in dark mode
  static Color get darkCardColor => SMAColors.darkContainer; // Same as dark container
  static Color get borderColor => SMAColors.borderPrimary; // Primary border color
  static Color get shadowColor => const Color(0x1A000000); // Semi-transparent shadow
  static Color get successColor => SMAColors.success; // Green for success messages
  static Color get warningColor => SMAColors.warning; // Orange for warnings
  static Color get infoColor => SMAColors.info; // Blue for informational messages

  // Helper method to get color based on theme
  static Color _getColor({required Color light, required Color dark}) {
    return WidgetsBinding.instance.window.platformBrightness == Brightness.dark ? dark : light;
  }
}


class SMAColors{
  SMAColors._();
  static const Color primary = Color (0xFF4b68ff);
  static const Color secondary = Color (0xFFFFE24B);
  static const Color accent = Color (0xFFb0c7ff);
  static const Color textPrimary = Color (0xFF333333);
  static const Color textSecondary = Color (0xFF6C757D);
  static const Color textWhite = Colors.white;
  static const Color light = Color (0xFFF6F6F6);
  static const Color dark = Color (0xFF272727);
  static const Color primaryBackground = Color (0xFFF3F5FF);
  static const Color lightContainer = Color (0xFFF6F6F6);
  static Color darkContainer = SMAColors.white.withOpacity(0.1);
  static const Color buttonPrimary = Color (0xFF4b68ff);
  static const Color buttonSecondary = Color (0xFF6C757D);
  static const Color buttonDisabled = Color (0xFFC4C4C4);
  static const Color borderPrimary = Color (0xFFD9D9D9);
  static const Color borderSecondary = Color (0xFFE6E6E6);
  static const Color error = Color (0xFFD32F2F);
  static const Color success = Color (0xFF388E3C);
  static const Color warning = Color (0xFFF57C00);
  static const Color info = Color (0xFF1976D2);
  static const Color black = Color (0xFF232323);
  static const Color darkerGrey = Color (0xFF4F4F4F);
  static const Color darkGrey = Color (0xFF939393);
  static const Color grey = Color (0xFFE0E0E0);
  static const Color softGrey = Color (0xFFF4F4F4);
  static const Color lightGrey = Color (0xFFF9F9F9);
  static const Color white = Color (0xFFFFFFFF);
}