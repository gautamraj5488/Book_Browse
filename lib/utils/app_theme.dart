import 'package:flutter/material.dart';
import 'colors.dart';
import 'text_styles.dart';

class AppTheme {
  static ThemeData get theme {
    return ThemeData(
      primaryColor: AppColors.primaryColor,
      hintColor: AppColors.accentColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      buttonTheme: const ButtonThemeData(
        buttonColor: AppColors.secondaryColor,
      ),
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.headingStyle,
        displayMedium: AppTextStyles.subheadingStyle,
        bodyLarge: AppTextStyles.bodyStyle,
      ),
    );
  }
}
