import 'package:flutter/material.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: Brightness.light,
      primary: AppColors.primaryGreen,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: CardThemeData(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.white,
      selectedColor: AppColors.lightGreen,
      labelStyle: TextStyle(color: AppColors.black87),
      secondaryLabelStyle: TextStyle(color: AppColors.white),
      checkmarkColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.orange,
      brightness: Brightness.light,
      primary: AppColors.primaryGreen,
    ),
    useMaterial3: true,
    appBarTheme: const AppBarTheme(centerTitle: true),
    cardTheme: CardThemeData(elevation: 4, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
    ),
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.white,
      selectedColor: AppColors.lightGreen,
      labelStyle: TextStyle(color: AppColors.black87),
      secondaryLabelStyle: TextStyle(color: AppColors.white),
      checkmarkColor: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
  );
}
