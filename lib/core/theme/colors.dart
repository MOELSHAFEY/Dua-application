import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary brand color
  static const Color primary = Color(0xFF0EA5E9);
  static const Color primaryLight = Color(0xFF38BDF8);
  static const Color primaryDark = Color(0xFF0284C7);

  // Accent color - Now Blue
  static const Color accent = Color(0xFF60A5FA);

  // Background
  static const Color background = Color(0xFFF8FAFC);
  static const Color scaffoldBackground = Color(0xFFF1F5F9);

  // Card & Surface
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textLight = Color(0xFF94A3B8);

  // Status colors - All Blue-themed
  static const Color success = Color(0xFF3B82F6);
  static const Color error = Color(0xFFEF4444); // Error remains red for safety/convention
  static const Color warning = Color(0xFF0284C7);
  static const Color info = Color(0xFF60A5FA);

  // Gradient colors
  static const Color gradientPrimaryStart = Color(0xFF0EA5E9);
  static const Color gradientPrimaryEnd = Color(0xFF38BDF8);

  static const Color gradientCardStart = Color(0xFFE0F2FE);
  static const Color gradientCardEnd = Color(0xFFF8FAFC);

  static const Color gradientHeaderMiddle = Color(0xFF0EA5E9);
  static const Color gradientHeaderEnd = Color(0xFF0284C7);
  
  // Grey shades
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
}
