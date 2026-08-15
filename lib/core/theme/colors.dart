import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary Medical Brand Color - Clean, professional medical blue
  static const Color primary = Color(0xFF0284C7); // Sky-600 (Light)
  static const Color primaryLight = Color(0xFF38BDF8); // Sky-400 (Dark primary)
  static const Color primaryDark = Color(0xFF0369A1); // Sky-700

  // Accent
  static const Color accent = Color(0xFF0D9488); // Teal-600
  static const Color accentLight = Color(0xFF2DD4BF); // Teal-400

  // Light Mode Backgrounds & Surfaces
  static const Color background = Color(0xFFF8FAFC); // Slate-50
  static const Color scaffoldBackground = Color(0xFFF8FAFC);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color border = Color(0xFFE2E8F0); // Slate-200
  static const Color borderLight = Color(0xFFF1F5F9); // Slate-100

  // Dark Mode Backgrounds & Surfaces
  static const Color backgroundDark = Color(0xFF0F172A); // Slate-900
  static const Color scaffoldBackgroundDark = Color(0xFF0F172A);
  static const Color cardBackgroundDark = Color(0xFF1E293B); // Slate-800
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceElevatedDark = Color(0xFF334155); // Slate-700
  static const Color borderDark = Color(0xFF334155); // Slate-700

  // Text Hierarchy - Light Mode
  static const Color textPrimary = Color(0xFF0F172A); // Slate-900
  static const Color textSecondary = Color(0xFF475569); // Slate-600
  static const Color textLight = Color(0xFF94A3B8); // Slate-400

  // Text Hierarchy - Dark Mode
  static const Color textPrimaryDark = Color(0xFFF8FAFC); // Slate-50
  static const Color textSecondaryDark = Color(0xFF94A3B8); // Slate-400
  static const Color textLightDark = Color(0xFF64748B); // Slate-500

  // Functional Status Colors - Light Mode
  static const Color success = Color(0xFF059669); // Emerald-600
  static const Color successLight = Color(0xFFECFDF5); // Emerald-50
  static const Color error = Color(0xFFDC2626); // Red-600
  static const Color errorLight = Color(0xFFFEF2F2); // Red-50
  static const Color warning = Color(0xFFD97706); // Amber-600
  static const Color info = Color(0xFF0284C7); // Sky-600

  // Functional Status Colors - Dark Mode
  static const Color successDark = Color(0xFF34D399); // Emerald-400
  static const Color successBackgroundDark = Color(0xFF064E3B); // Emerald-900
  static const Color errorDark = Color(0xFFF87171); // Red-400
  static const Color errorBackgroundDark = Color(0xFF7F1D1D); // Red-900
  static const Color warningDark = Color(0xFFFBBF24); // Amber-400

  // Gradients
  static const Color gradientPrimaryStart = Color(0xFF0284C7);
  static const Color gradientPrimaryEnd = Color(0xFF0369A1);

  // Neutral Greys
  static const Color grey50 = Color(0xFFF8FAFC);
  static const Color grey100 = Color(0xFFF1F5F9);
  static const Color grey200 = Color(0xFFE2E8F0);
  static const Color grey300 = Color(0xFFCBD5E1);
  static const Color grey400 = Color(0xFF94A3B8);
  static const Color grey700 = Color(0xFF334155);
  static const Color grey800 = Color(0xFF1E293B);
  static const Color grey900 = Color(0xFF0F172A);

  // Helper getters for context-aware styling
  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color getPrimary(BuildContext context) {
    return isDark(context) ? primaryLight : primary;
  }

  static Color getCardColor(BuildContext context) {
    return isDark(context) ? cardBackgroundDark : cardBackground;
  }

  static Color getBorderColor(BuildContext context) {
    return isDark(context) ? borderDark : border;
  }

  static Color getTextPrimary(BuildContext context) {
    return isDark(context) ? textPrimaryDark : textPrimary;
  }

  static Color getTextSecondary(BuildContext context) {
    return isDark(context) ? textSecondaryDark : textSecondary;
  }

  static Color getSurfaceMuted(BuildContext context) {
    return isDark(context) ? surfaceElevatedDark : grey50;
  }
}
