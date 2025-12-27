import 'package:flutter/material.dart';

class AppColors {
  static const purple = Color(0xFF8A66FF);
  static const purpleDark = Color(0xFF6F4FFF);
  static const purpleLight = Color(0xFFEDE8FF);
  static const bg = Color(0xFFF9F9FB);
  static const text = Color(0xFF1C1C1E);
  static const textSecondary = Color(0xFF8E8E93);
  static const green = Color(0xFF34C759);
  static const red = Color(0xFFFF3B30);
  static const orange = Color(0xFFFF9500);
  static const card = Colors.white;
  static const divider = Color(0xFFE5E5EA);
}

ThemeData buildTheme() {
  final base = ThemeData(
    useMaterial3: true,
    fontFamily: 'SF Pro', // optional; use default if not available
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.purple),
  );
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.bg,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.bg,
      foregroundColor: AppColors.text,
      elevation: 0,
      centerTitle: true,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF4F5F7),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      labelStyle: const TextStyle(color: AppColors.textSecondary),
    ),
    dividerColor: AppColors.divider,
  );
}