import 'package:flutter/material.dart';
import 'colors.dart';

class AppTextStyles {
  final double screenWidth;
  final double screenHeight;


  AppTextStyles(BuildContext context)
      : screenWidth = MediaQuery.of(context).size.width,
        screenHeight = MediaQuery.of(context).size.height;

  TextStyle get headingStyle => TextStyle(
        fontSize: screenWidth > 600 ? 24 : 18,
        fontWeight: FontWeight.bold,
        color: AppColors.textColor,
      );

  TextStyle get subheadingStyle => TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textColor,
      );

  TextStyle get bodyStyle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
        color: AppColors.textColor,
      );

  TextStyle get buttonTextStyle => TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: AppColors.whiteColor,
      );
}
