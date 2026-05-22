import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary
  static const Color primary = Color(0xFF1B5E20);
  static const Color primaryLight = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF003300);

  // Accent
  static const Color accent = Color(0xFFA5D6A7);
  static const Color accentDark = Color(0xFF388E3C);

  // Amber / Highlights
  static const Color amber = Color(0xFFFF8F00);
  static const Color amberLight = Color(0xFFFFCC02);
  static const Color amberDark = Color(0xFFE65100);

  // Blue (Disease Detection module)
  static const Color blue = Color(0xFF1565C0);
  static const Color blueLight = Color(0xFF1976D2);

  // Backgrounds
  static const Color background = Color(0xFFF1F8E9);
  static const Color surfaceWhite = Colors.white;
  static const Color cardColor = Colors.white;

  // Text
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFBDBDBD);
  static const Color textWhite = Colors.white;

  // Status
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF57C00);
  static const Color error = Color(0xFFD32F2F);
  static const Color info = Color(0xFF0288D1);

  // Chart / Data Colors
  static const Color chartGreen = Color(0xFF4CAF50);
  static const Color chartAmber = Color(0xFFFFC107);
  static const Color chartRed = Color(0xFFEF5350);
  static const Color chartBlue = Color(0xFF42A5F5);

  // Gradients
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
  );

  static const LinearGradient cropModuleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
  );

  static const LinearGradient maintenanceModuleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFE65100), Color(0xFFFF6D00)],
  );

  static const LinearGradient diseaseModuleGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1565C0), Color(0xFF1976D2)],
  );

  static const LinearGradient farmHeaderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1B5E20), Color(0xFF388E3C)],
  );

  // Divider
  static const Color divider = Color(0xFFE0E0E0);

  // Overlay
  static Color overlayDark = Colors.black.withValues(alpha: 0.5);
  static Color overlayLight = Colors.white.withValues(alpha: 0.1);
}
