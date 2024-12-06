import 'package:flutter/material.dart';
import 'colors.dart';
import 'package:book_browse/utils/text_styles.dart'; // Ensure AppTextStyles is correctly imported

class AppTheme {
  // Light Theme
  static ThemeData lightTheme(BuildContext context) {
    AppTextStyles textStyles = AppTextStyles(context);

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: AppColors.primaryColor,
      secondaryHeaderColor: AppColors.secondaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      appBarTheme: AppBarTheme(
        color: AppColors.appBarColor,
        titleTextStyle: TextStyle(
          color: AppColors.appBarTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
        displayLarge: textStyles.headingStyle.copyWith(color: AppColors.textColor),
        displayMedium: textStyles.subheadingStyle.copyWith(color: AppColors.textColor),
        bodyLarge: textStyles.bodyStyle.copyWith(color: AppColors.textColor),
        labelLarge: textStyles.buttonTextStyle.copyWith(color: AppColors.buttonTextColor),
      ),
      cardTheme: CardTheme(
        color: AppColors.cardColor,
        elevation: 4,
        shadowColor: AppColors.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.borderColor),
        ),
      ),
      colorScheme: ColorScheme.light(
        background: AppColors.backgroundColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        onPrimary: AppColors.textColor,
        onSecondary: AppColors.textColor,
        surface: AppColors.cardColor,
        onSurface: AppColors.textColor,
        onBackground: AppColors.textColor,
        error: AppColors.errorColor,
        onError: AppColors.whiteColor,
      ),
    );
  }

  // Dark Theme
  static ThemeData darkTheme(BuildContext context) {
    AppTextStyles textStyles = AppTextStyles(context);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: AppColors.primaryColor,
      secondaryHeaderColor: AppColors.secondaryColor,
      scaffoldBackgroundColor: AppColors.backgroundColor,
      appBarTheme: AppBarTheme(
        color: AppColors.appBarColor,
        titleTextStyle: TextStyle(
          color: AppColors.appBarTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: AppColors.buttonColor,
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
        displayLarge: textStyles.headingStyle.copyWith(color: AppColors.whiteColor),
        displayMedium: textStyles.subheadingStyle.copyWith(color: AppColors.whiteColor),
        bodyLarge: textStyles.bodyStyle.copyWith(color: AppColors.whiteColor),
        labelLarge: textStyles.buttonTextStyle.copyWith(color: AppColors.buttonTextColor),
      ),
      cardTheme: CardTheme(
        color: AppColors.darkCardColor,
        elevation: 4,
        shadowColor: AppColors.shadowColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: AppColors.borderColor),
        ),
      ),
      colorScheme: ColorScheme.dark(
        background: AppColors.backgroundColor,
        primary: AppColors.primaryColor,
        secondary: AppColors.secondaryColor,
        onPrimary: AppColors.whiteColor,
        onSecondary: AppColors.whiteColor,
        surface: AppColors.darkCardColor,
        onSurface: AppColors.whiteColor,
        onBackground: AppColors.whiteColor,
        error: AppColors.errorColor,
        onError: AppColors.whiteColor,
      ),
    );
  }
}
